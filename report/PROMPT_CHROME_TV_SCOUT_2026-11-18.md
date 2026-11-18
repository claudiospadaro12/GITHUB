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

## Prompt aggiuntivo (ricerca ampliata, 20 script)
Richiesta di Claudio: obiettivo = un Pine che generi buoni segnali, indipendentemente dallo stile; poi se ne fa un EA nostro.
```
OBIETTIVO AGGIUNTIVO: ampliare la ricerca fatta nel primo prompt. Trovare e salvare il CODICE SORGENTE di altri 20 script open-source di TradingView che generano SEGNALI di ingresso (long e short) chiari, di QUALSIASI stile, adatti a XAUUSD ed EURUSD in H1. Non importa lo stile: contano segnali ben definiti e codice leggibile. Escludi gli script gia salvati nel primo zip (stesso nome o stesso link).

REGOLE DI SICUREZZA (le stesse del primo prompt, obbligatorie)
- Nessun login, acquisto, abbonamento, Follow/Like/Boost, commento, click su pubblicita, download di eseguibili. Se compare un login o un pagamento, FERMATI e scrivilo.
- Non inventare nulla. Codice copiato ESATTAMENTE come e scritto. Se non si legge come testo: "codice non estratto" e passa oltre.

QUATTRO GRUPPI da 5 script ciascuno (https://www.tradingview.com/scripts/ con filtro "Open-source only", ordinamento "Top"; per ogni parola chiave guarda i primi 10-15 risultati)
A) STRATEGIE (tipo "Strategies", non "Indicators": sono script strategy() con ingressi e uscite espliciti): parole chiave "strategy", "breakout strategy", "trend strategy", "mean reversion strategy", "momentum strategy".
B) TREND-FOLLOWING: "trend following", "supertrend", "ema cross", "adx trend", "ichimoku", "moving average trend", "turtle".
C) PRICE ACTION E STRUTTURA: "market structure", "break of structure", "order block", "supply demand", "liquidity sweep", "fair value gap", "candlestick pattern", "support resistance", "wyckoff", "smart money".
D) MOMENTUM, VOLATILITA, VOLUME con segnali: "squeeze", "keltner", "atr breakout", "volume profile signal", "vwap reversion", "divergence", "multi timeframe signal".

SCARTA SUBITO
- codice chiuso, protetto o invite-only;
- script che mostrano solo livelli, zone o dashboard senza regola di ingresso;
- cloni banali di RSI, MACD, medie mobili, Bollinger standard;
- script con parole da marketing senza regole ("AI", "predictive", "never loses", "99% accuracy") o dichiaratamente "repainting" dall'autore.
PREFERISCI: segnali con alertcondition() o plotshape/label chiari; autore che dichiara che il segnale compare a candela chiusa o "non repaint"; parametri pochi e spiegati; molti Like/Boost.

PER OGNI SCRIPT
1. Copia TUTTO il codice Pine in <NN>_<gruppo>_<nome>.pine (NN da 11 a 30; gruppo A/B/C/D).
2. Annota: nome, autore, link (senza tracciamento), data, versione Pine, **licenza**, like/boost, gruppo, la logica in UNA frase, le condizioni di ingresso LONG e SHORT come le descrive l'autore, se esiste un'uscita o uno stop.
3. Scrivi SI o NO per le parole nel codice: "lookahead", "request.security", "ta.pivothigh", "ta.pivotlow", "barstate.isrealtime", "calc_on_every_tick", "alertcondition", "strategy(". Non giudicare.

OUTPUT
1. Tabella in italiano (una riga per script): NN | gruppo | nome | autore | link | data | versione | licenza | like/boost | logica | ingresso long | ingresso short | uscita/stop | lookahead | request.security | pivothigh | pivotlow | realtime | alertcondition | strategy.
2. Zip TV_SCOUT2_<AAAA-MM-GG>.zip con: 00_info.txt (data e ora italiana, parole chiave, pagine non aperte e perche), 01_tabella.csv (;, UTF-8) e i 20 file .pine. Massimo 10 MB (se serve _parte1 e _parte2).
3. Alla fine dimmi quanti script hai estratto con codice completo, quali no e perche, posizione e dimensione dello zip.
NON dare giudizi su quale sia il migliore e non suggerire parametri o operativita.
```

## Risposta all'estensione: 20 link diretti (18/11/2026)
Link presi dalle pagine di ricerca pubbliche di TradingView (non aperti uno a uno da me; lo stato "open-source" va verificato sulla pagina). Messaggio da incollare all'estensione:
```
Ecco 20 link diretti. Aprili uno a uno, SENZA ricerche. Per ciascuno: (1) verifica sulla pagina che sia OPEN-SOURCE (se e protetto, invite-only o chiuso: scrivi "chiuso" e passa al successivo); (2) apri il sorgente e copia TUTTO il codice Pine esattamente come e in <NN>_<nome>.pine; (3) annota nome, autore, link, data, versione Pine, licenza, like/boost, logica in una frase, condizioni di ingresso long/short, uscita/stop; (4) SI/NO per: lookahead, request.security, ta.pivothigh, ta.pivotlow, barstate.isrealtime, calc_on_every_tick, alertcondition, strategy(. Poi crea lo zip TV_SCOUT_<AAAA-MM-GG>.zip con 00_info.txt, 01_tabella.csv (;, UTF-8) e i file .pine, massimo 10 MB, e dimmi quanti hai estratto, quali no e perche. Stesse regole di sicurezza di prima (nessun login, acquisto, Follow/Like/Boost, commento).

BREAKOUT
1 https://www.tradingview.com/script/KvxtErD5-Breakout-Range-Long-Strategy/
2 https://www.tradingview.com/script/ecFS6HNX-Breakout-Range-Short-Strategy/
3 https://www.tradingview.com/script/EvkXjgyw-Breakout-Finder/
4 https://www.tradingview.com/script/27kn3NDw-Breakout-Detector-Previous-MTF-High-Low-Levels-LuxAlgo/
5 https://www.tradingview.com/script/G6YAAhmL-Breakout/
6 https://www.tradingview.com/script/MaFckffw-Breakout-Pattern-Setup-WillyAlgoTrader/
7 https://www.tradingview.com/script/UEbrJcmh-donchian-channel-strategy/
8 https://www.tradingview.com/script/SlYz8Ptk-Donchian-Channels-strategy-with-backtest/
9 https://www.tradingview.com/script/5hV7cFAS-Squeeze-Momentum-Indicator-AGPro-Series/
MEAN-REVERSION
10 https://www.tradingview.com/script/RwVTfoTY-Statistical-Mean-Reversion-Engine-SMRE/
11 https://www.tradingview.com/script/RZ1GZGP3-Jaws-Mean-Reversion-Strategy/
12 https://www.tradingview.com/script/XRPeqEdA-Bollinger-Bands-Mean-Reversion-using-RSI-Krishna-Peri/
13 https://www.tradingview.com/script/JFIZkwZR-RSI-Mean-Reversion/
14 https://www.tradingview.com/script/92rilzXd-Z-Score-Mean-Reversion-Pro/
15 https://www.tradingview.com/script/tF22td3U-Mean-Reversion-Pro/
16 https://www.tradingview.com/script/17890vUp-Mean-Reversion-Channel-TradingFinder-ATR-Band-Reversal-Signals/
17 https://www.tradingview.com/script/rdO5c5yP-Mean-Reversion-and-Momentum-Updated-with-gaussiana-smoothing/
TREND
18 https://www.tradingview.com/script/r6dAP7yi/
19 https://www.tradingview.com/script/6jXh1FKG-Supertrend-Confirmed-Close-forexs/
20 https://www.tradingview.com/script/dTn0p5mz-Supertrend/
```

## Comando per l'estensione: estrazione ESATTA di 8 script (18/11/2026)
```
Ora estrai in modo ESATTO il sorgente di questi 8 script. L'indentazione e vincolante nel Pine, quindi il testo deve conservare spazi e a-capo identici all'originale. Per ciascuno prova i metodi in questo ordine e fermati al primo che funziona:
METODO A (preferito): nella pagina dello script apri la scheda "Codice sorgente". Il visualizzatore mostra solo le righe visibili: scorri il codice dall'inizio alla fine, a passi di una schermata, e a ogni passo leggi il testo di ogni riga (textContent, non innerText) sostituendo gli spazi non separabili (carattere U+00A0) con spazi normali, e conserva il numero di riga. Unisci le righe in ordine di numero di riga, senza duplicati e senza righe mancanti. Controllo: il numero di righe ricostruito deve coincidere con l'ultimo numero di riga mostrato dal visualizzatore.
METODO B: premi il pulsante "Copia" del codice sorgente, incolla il contenuto in una casella di testo (textarea) di una pagina vuota che apri tu, e leggi il valore della casella (value): conserva gli spazi. Se non puoi incollare o leggere, passa al metodo C.
METODO C: se nessuno dei due funziona, scrivi "NON ESATTO" per quello script, salva comunque la versione che hai ottenuto in una cartella "non_esatti" e vai avanti.
VERIFICA di ogni file prima di salvarlo: la prima riga deve essere "//@version=..." (o un commento di licenza che la precede); le righe dentro if, for, while, funzioni e "=>" devono avere rientro (di solito 4 spazi); nessuna riga deve avere i rientri persi; le parentesi devono essere bilanciate. Se un controllo fallisce, il file e non esatto.
Salva ogni file come <NN>_<nome>.pine con NN da 21 a 28, SENZA modificare niente. Annota in 01_tabella.csv: NN, nome, autore, link, data, versione Pine, licenza, numero di righe, metodo usato (A/B/C), esatto (SI/NO), strategy( o study/indicator, lookahead, request.security, ta.pivothigh, ta.pivotlow, barstate.isrealtime, calc_on_every_tick, alertcondition (SI/NO).
Crea lo zip TV_SCOUT_8_<AAAA-MM-GG>.zip con 00_info.txt (quanti esatti, quali non esatti e perche, metodo per ciascuno), 01_tabella.csv (;, UTF-8), i .pine esatti e la cartella non_esatti. Massimo 10 MB. Se arrivi al limite, salva uno zip parziale ogni 3 script.
Regole di sicurezza invariate: nessun login, acquisto, Follow/Like/Boost, commento. Se uno script risulta protetto o a codice chiuso scrivilo e passa al successivo.

21 https://www.tradingview.com/script/RZ1GZGP3-Jaws-Mean-Reversion-Strategy/
22 https://www.tradingview.com/script/UEbrJcmh-donchian-channel-strategy/
23 https://www.tradingview.com/script/SlYz8Ptk-Donchian-Channels-strategy-with-backtest/
24 https://www.tradingview.com/script/XRPeqEdA-Bollinger-Bands-Mean-Reversion-using-RSI-Krishna-Peri/
25 https://www.tradingview.com/script/JFIZkwZR-RSI-Mean-Reversion/
26 https://www.tradingview.com/script/92rilzXd-Z-Score-Mean-Reversion-Pro/
27 https://www.tradingview.com/script/EvkXjgyw-Breakout-Finder/
28 https://www.tradingview.com/script/RwVTfoTY-Statistical-Mean-Reversion-Engine-SMRE/
```
