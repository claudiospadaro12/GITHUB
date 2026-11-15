# UBS sull'oro: cercare strategie NON correlate ai breakout con il rimbalzo al livello — CRITERI e PREVISIONI (15/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, nessuna riga lanciata, nessun numero nuovo.** Obiettivo di Claudio (14-15/11/2026): trovare EA non correlati sull'oro con UBS (che ha comprato). Idea: "quando non rompe il livello e rimbalza" (ingresso limit al livello). Solo tester su PC di backtest; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## Cosa UBS fa e cosa no (da `UBS_PACCHETTO_WIM/UBS_scheda_2026-11-04.md` e dal report Discord di ottobre)
- UBS e un **costruttore di breakout** con 3 modelli d'ingresso: breakout di supporto/resistenza (ordini pendenti stop), di volatilita, di range. **Non ha un modello "limit di rimbalzo" nativo** (da confermare sul manuale 8.3).
- **`ReverseTrades`** (Wim, 12/10): inverte buy e sell, **solo per l'ingresso su rottura S/R**, parametro di ogni set. Wim: aggiunto "not because I think it's a great idea". Il nome esatto dell'input va CONFERMATO nella scheda Inputs di MT5.
- **Break & retest**: Wim non ha trovato set profittevoli sull'oro: "I don't really recommend using it" (28/10).
- Esiste un filtro "fake breakout" (da leggere sul manuale).
**Quindi** il rimbalzo al livello si approssima con `ReverseTrades`: il segnale del breakout diventa un ingresso contro la rottura. Non e lo stesso di un ordine limit al livello: lo dichiaro.

## Domanda
Con `ReverseTrades` acceso, i set oro S/R di UBS danno trade con (a) rendimento positivo dopo i costi e (b) correlazione bassa o negativa con i nostri portafogli oro (P1, P3, P4)?

## Disegno (nessuna ottimizzazione)
- **Set**: i set oro in formato UBS gia misurati in U1b-U5 (37 nel pacchetto da 283, 4 nel V9.0 con candela di conferma); si usano solo quelli in cui l'input `ReverseTrades` ESISTE (si legge dal report del tester: input mancante = passata KO, e si scrive).
- **Passate**: ogni set due volte, versione originale (gia misurata, `ubsu3m.json`/U1b) e versione con `ReverseTrades=true`; XAUUSD, Modello 1, 100.000 EUR, lotto fisso 0,1, periodi P1 2013-2018 e P2 2019-2025 come U3; **nessun altro input cambiato**.
- **Misure**: netto, PF, operazioni, DD equity, DD01 (DD/10), correlazione giornaliera del realizzato con la versione originale e con i portafogli oro P1/P3/P4 (dai report tester gia in archivio).

## Regole di lettura (fissate ora)
- **Un set invertito PASSA** se in ENTRAMBI i periodi: operazioni >= 150, PF >= 1,20, netto > 0, nessuno stop out, rapporto DD01(P2)/DD01(P1) fra 0,5 e 2; e la correlazione con P1/P3/P4 <= 0,30.
- Se **nessuno** passa: stop, nessuna ottimizzazione per forzare l'esito; si valuta un EA nostro con ordini limit (strada 2 della chat del 14/11).
- Un set invertito che "migliora" solo dopo ritocchi dei parametri non vale.

## Previsioni dichiarate ORA (non misurate)
- **R-1** L'input esiste e funziona in almeno il 60% dei set provati: 70%.
- **R-2** Per i set con PF originale > 1,3 il PF invertito e < 1 in almeno l'80% dei casi (invertire un breakout che guadagna di norma perde, e i costi pesano due volte): 85%.
- **R-3** Almeno UN set invertito passa tutti i filtri: 15%.
- **R-4** La correlazione giornaliera invertito-originale e <= -0,5 per la maggior parte dei set: 70%.
- **R-5** Nessun set invertito ha, dopo i costi FTMO misurati (commissione oro 5,1 EUR/lotto, slippage di entrata medio circa 0,4 USD/oncia), un rendimento migliore del suo originale: 85%.

## Limiti dichiarati
`ReverseTrades` non e un ingresso limit al livello; un percorso per set; Modello 1 (le uscite a tick possono cambiare); i set sono nati per il breakout (SL/TP e trailing non sono pensati per l'inverso); costi FTMO non applicati nel tester; la correlazione e sul realizzato giornaliero, non sull'equity.
