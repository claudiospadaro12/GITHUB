# Le due video lezioni di Leonardo sulle bande di Bollinger (Breaking Band): sintesi e confronto (19/11/2026)
Fonte: due trascrizioni TurboScribe (`LEONARDO_VIDEO_dati/`, circa 9.500 parole): `video1406537954` (prima lezione: concetti e regole, H1/H4/M30, esempi su EURUSD e altri cross) e `video1108592336` (seconda lezione: verifica degli screenshot dell'allievo, M5/M15, commodity, notizie). **I fotogrammi non servono per le regole: il testo le dice tutte.**

## Le regole spiegate (in parole nostre)
1. **Squeeze -> bulge:** fase laterale a bande strette, poi esplosione di volatilita con bande a "palloncino/uccellino"; l'impulso e diretto con candele grosse; la bulge deve essere evidente e "armonica", non sporca.
2. **Continuazione (a favore dell'impulso):** si entra al **ritracciamento che tocca la banda OPPOSTA** (anche con ordine limite appena oltre la banda); le candele del ritracciamento devono essere **piu piccole** di quelle dell'impulso ("sale con l'ascensore, scende con le scale"); il ritracciamento deve essere diretto, non una nuova squeeze; solo se le bande si sono ristrette (**deviazione standard sotto la sua media a 50 periodi**: "ricordo: solo per la continuazione").
3. **Inversione (contro l'impulso):** impulso -> tocca la **mediana** (o la supera) -> **ritocca la banda dell'impulso** ("pattern a M"): si entra contro, **a patto che la banda dell'impulso sia piatta o a favore della posizione** (si guardano le 3 candele precedenti); se la banda e ripida contro, non si entra.
4. **Contesto:** prima bulge -> continuazione; seconda e terza bulge -> inversione ("scenario ideale"); niente **band riding** (prezzo che corre tra mediana e banda); bulge che arriva da un trend lungo = peggio; "se non e perfettamente chiaro, lascia perdere".
5. **Uscita e stop:** take profit **sulla mediana**, da **aggiornare** mentre la mediana si muove; **stop = 3 ATR** (molto ampio, "non si ha fretta"); ingresso a mercato o con limite; rischio **2%** (esempio su demo da 4.900).
6. **Timeframe:** H1, H4 e M30 "il pattern cosi com'e"; D1 possibile ma lento; **M5 e M15** con regole diverse: si opera solo ai livelli di H1 (parte alta o bassa della banda H1, banda H1 piatta o a favore), serve una bulge su M5 e un "pattern a M", stop 3 ATR di M5 (esempio 18 pip), tenuta 30-60 minuti.
7. **Orari e notizie (H1):** ideale la **mattina, 7-9** (ora italiana); chiudere in mattinata; **evitare di tenere aperto** attraverso notizie sulla valuta (14:30); controllare Forex Factory e Investing; su M5 margine di mezz'ora dalla notizia, su M15 un'ora.
8. **Statistica dichiarata:** "9 operazioni su 10 vanno bene"; vincita media 0,5%, perdita 2% (rapporto circa 1:3-4): con 90% di vittorie il risultato sarebbe circa +2,5% ogni 10 operazioni.

## Confronto con quello che abbiamo misurato
| Punto | Leonardo | Nostre misure |
|---|---|---|
| Percentuale di vittorie | circa 90% | oro H1 (sala del consiglio, 01/11): 64% (INCONCLUSIVO, 25 operazioni); **forex H1 anni nuovi: 73,5%** contro pareggio 75,9%, R medio +0,006, PF 1,03 (NON DIMOSTRATO, 49 operazioni); Bulge motore corretto: PF 0,83; BreakingBand v4 (Massimo): 11-13 operazioni per simbolo, OOS sottile |
| Geometria | stop 3 ATR, target sulla mediana (circa 1 ATR) | pareggio circa 76-78% di vittorie; il vantaggio dichiarato (90%) non si ripete: regressione verso la media |
| Regole di ingresso | come sopra | in gran parte gia codificate nella v2/v4 (bulge, ritracciamento ordinato, esaurimento con deviazione standard sotto SMA50, inversione con almeno 2 bulge, stop 3 ATR, target mediana) |
**Perche il 90% non si vede nei test:** gli esempi del video sono scelti a occhio ("qui compro, qui chiudo", "questa non la considero una bulge", "un po' sporca, lascio perdere"): il **giudizio visivo selettivo** decide quali setup contano, e fatto sul passato scarta i perdenti. Il codice non puo copiarlo; i test automatici danno 73-74%.

## Cosa c'e di NUOVO e non ancora provato
1. **Filtro orario e notizie** (mattina 7-9; niente posizioni aperte attraverso notizie sulla valuta): la sala lo aveva classificato "non misurabile". **Ora lo e:** abbiamo un calendario storico MT5 esportato (`abtg_news_hist.csv`, USD ed EUR, dal 2013; estendibile alle altre valute).
2. **M30/M15/M5 con contesto H1** (livelli di H1, banda H1 piatta o a favore): M15 non era mai stato testato; M30 si (N 191, R +0,013).
3. **Ordini limite al livello della banda** al posto dell'ingresso a mercato dopo la chiusura.
4. **Aggiornamento continuo del target** sulla mediana (nella v2 c'e un ricalcolo ogni 3 ore).
Mancano i documenti citati nelle lezioni e inviati per email all'allievo: **"protocollo operativo scritto" e "protocollo per le bande M5"**: sarebbero la fonte esatta per M5/M15.

## Proposta (decide Claudio)
Il quadro non cambia: la strategia con le sue regole non ha un vantaggio dimostrato. L'unico filone con una possibilita non nulla e **testare i filtri nuovi (orario mattina + notizie + M30) su BreakingBand v4** con un campione piu grande (circa 28 cross, 13 anni). Peso: una riga di passate per simbolo (circa 1-2 ore) e analisi moderata; aspettativa realistica bassa (il filtro dovrebbe portare la vittoria da 73% a oltre 78%).

## Fotogrammi (19/11/2026, 195 + 168 fotogrammi, uno ogni 20 s; visti 3 fogli e 1 fotogramma a piena risoluzione)
Confermano le trascrizioni, **nessuna regola nuova**. Si vede: TradingView, AUDUSD H1 (Pepperstone), indicatore **"BB 20 SMA close 2"** (Bollinger 20 periodi, 2 deviazioni, media semplice sulla chiusura) e pannello **"ATR 14 RMA"** (ATR di Wilder, non la media semplice dell'iATR di MT5: differenza piccola, gia nota); disegni a mano dell'"uccellino" sulla bulge, linee sul tocco della banda opposta, la scritta "squeeze" e "BULGE"; nella seconda lezione grafici su vari cross, un sito web di **calcolo della size** (EUR/GBP, rischio 2%) e la piattaforma **cTrader** per gli ordini limite.
