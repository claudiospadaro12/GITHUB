# MULTI TF BIAS DASHBOARD: cosa e, cosa si puo e non si puo fare per un EA (26/10/2026)
**Natura: LETTURA di 2 screenshot (finestra "Dati in ingresso" su D30EUR M5), del PDF `MULTI_TF_BIAS_DASHBOARD_Guida.pdf` (5 pagine) e del file `.ex5`. Non controllata da agenti.** Richiesta di Claudio: "analizzami questo indicatore che dicono sia ottimo e se si puo creare un EA". Nessun acquisto, lotto o taglia e mio.

## Cosa e (DICHIARATO dalla guida)
Una **dashboard informativa** (il titolo della finestra: `BAN_MULTI_TF_BIAS_DASHBOARD 1.00`): per ogni timeframe W1, D1, H4, H1, M15 mostra bias (BULLISH/BEARISH/NEUTRAL), score 0-100, forza, "confidenza", struttura (HH/HL, LH/LL, BOS, CHoCH) e note (CONTRO-TREND, WEAKENING, BIAS CHANGING); in fondo un **Overall Bias** pesato (W1 30%, D1 25%, H4 20%, H1 15%, M15 10%), l'allineamento (es. 4/5 BULLISH) e un avviso di possibile cambio di bias. **"Non e un sistema di trading: non apre e non chiude posizioni, non dice COMPRA o VENDI, non suggerisce entry, stop loss o take profit."** Solo candele chiuse (niente repaint). Ogni timeframe usa solo i propri dati.
Lo score per timeframe e una media pesata di cinque voti da -100 a +100: **Market Structure 30%** (massimi/minimi, rotture BOS/CHoCH), **Trend EMA 20/50/200 25%** (prezzo sopra/sotto, ordine, pendenza, ampiezza), **Momentum 20%** (RSI sopra 55 / sotto 45, MACD), **Price Action 15%** (chiusure vicino a massimi/minimi, corpi, ombre), **Volume (tick) 10%** (solo conferma). Sotto lo score 15 il timeframe e NEUTRAL. "Confidenza" = accordo fra gli strumenti, **non una probabilita** (lo scrive la guida). Le news (calendario MT5) non entrano nello score e **non funzionano nel tester**.

## Impostazioni lette dagli screenshot (VERIFICATO)
Simbolo vuoto = grafico corrente; timeframe W1, D1, H4, H1, M15 tutti attivi; EMA 20/50/200; RSI 14; MACD 12/26/9; ATR 14 (solo normalizzazione); barre per pendenza EMA 5; lookback struttura 150 barre; forza swing 3 barre per lato; price action 8 candele; analisi volume e price action attive; pesi componenti 30/25/20/15/10; pesi timeframe 30/25/20/15/10; solo candele chiuse = true; soglia NEUTRAL 15; candele per cambio bias 6; variazione minima di score per avviso 20; conferme minime 2 su 4; informazioni esterne false; aggiornamento 60 secondi; parametri grafici (posizione, font, trasparenza).

## Il file `.ex5` (VERIFICATO)
127.038 byte, SHA256 `f5cb236a...c6003d`, intestazione `EX5` versione 4: **compilato, nessun sorgente leggibile**. La guida dice di installare un `MULTI_TF_BIAS_DASHBOARD.mq5` e compilarlo con F7: **il sorgente esiste ma non e stato mandato**.

## Si puo fare un EA? Quattro strade
1. **Chiedere il `.mq5`** (la guida ne parla). Con il sorgente l'EA e semplice e fedele: si copiano le funzioni di punteggio e si decide a quale combinazione di bias agire. **E la strada migliore.**
2. **Leggere l'indicatore dall'EA (`iCustom`)**: dipende dai suoi buffer. Una dashboard disegnata con oggetti grafici potrebbe non avere buffer: NON VERIFICATO. Si puo verificare sul tuo terminale con uno script di sonda (elenco buffer e prova di `CopyBuffer`). Anche con buffer, **nel tester gli oggetti grafici dell'indicatore non ci sono**, quindi niente verifica dei risultati.
3. **Leggere i testi della dashboard su un grafico dal vivo** (gli oggetti hanno testo, es. "BULLISH 81/100"): possibile solo dal vivo, mai nel tester.
4. **Ricostruire l'indicatore dalle regole della guida** (replica dichiarata): le componenti e i pesi sono noti, ma **non le formule esatte** (come si traduce "ordine delle medie" o "corpi pieni" in un voto). Sarebbe **una mia versione, non il loro prodotto**: i numeri non coinciderebbero con la dashboard. Si puo validarla confrontando con la dashboard dal vivo su alcune ore.

## Cosa penso (lettura, non un giudizio)
- E una **sintesi di indicatori classici** (struttura, medie, RSI, MACD, candele, volumi) che sono tutti in ritardo: funziona come **filtro di tendenza**. Che sia "ottimo" **non e dimostrato da nulla nella guida**: nessun dato di risultato, nessun test. Un filtro di tendenza di questo tipo ha un comportamento noto: aiuta quando il mercato va in una direzione e peggiora nei laterali e ai cambi di tendenza. Lo stesso schema che abbiamo gia visto: il vantaggio dipende dal regime.
- Un **EA basato solo sul bias** non esiste "gia dentro" l'indicatore: mancano ingresso, stop e uscita. Le regole di trading sarebbero mie da inventare e quindi da provare come ipotesi, non come promessa dell'indicatore.

## Cosa propongo (nulla viene costruito prima dei criteri scritti)
1. **Test del segnale, senza EA:** il bias (con il sorgente o con la replica) predice il movimento successivo? Domanda precisa, criteri scritti prima: per esempio, nei momenti con allineamento >= 4/5 e HTF concordi, il rendimento delle ore o dei giorni seguenti nella direzione del bias e migliore del caso, su oro e sugli indici, con i dati che abbiamo (oro D1 dal 2004; M1 2026; indici dal 2024). E in regimi diversi (long, short, laterale), come gia fatto per gli EA.
2. **Solo se il passo 1 mostra qualcosa**, un EA con regole dichiarate (per esempio: ingresso nella direzione del bias dopo la fine della correzione M15, stop in ATR, uscita a rischio/rendimento fisso), provato sui tre regimi e a 5.000 EUR, con le stesse soglie di solidita degli altri EA. Lotti e rischio li sceglie Claudio.
3. In ogni caso un **uso gia utile senza EA**: come filtro delle direzioni dei nostri EA (non operare long contro un bias SHORT forte), da verificare con lo stesso metodo.

## Cosa mi serve da Claudio
- **Il file `MULTI_TF_BIAS_DASHBOARD.mq5`** se lo ha (il fornitore lo cita nella guida). Senza, vado con la replica.
- Su quale simbolo e timeframe lo usi (lo screenshot e D30EUR M5) e su che cosa lo vorresti far lavorare (solo direzione, o ingressi).
- Facoltativo: due o tre screenshot della dashboard dal vivo con data e ora, per confrontare una eventuale replica.
