# Arena sul reale -- misura di SOLA LETTURA sul conto 10105439 (15/10/2026)

Richiesta di Claudio: «misura di sola lettura sul reale: mandami la riga». Il conto reale resta suo: nessun tocco da parte mia.

## Cosa si puo' leggere a mano, senza codice, senza scrivere nella cartella del reale (terminale C:\BCM_Reale, conto 10105439)
1. **Specifica di XAUUSD** (Visualizza > Market Watch > tasto destro su XAUUSD > Specifica): dimensione contratto, margine iniziale/mantenimento/hedge, swap long e short, livello degli stop, livello di congelamento, modo di esecuzione, filling, volume min/step/max, orari di sessione.
2. **Spread vivo** di XAUUSD (colonna Spread del Market Watch, a mostrare Spread: tasto destro > Colonne) in alcuni istanti: apertura Londra, apertura New York, un dato USA, la sera.
3. **Leva e margine del conto**: Finestra strumenti > Trade (riga del conto: Saldo, Equity, Margine, Margine libero, Livello di margine) e leva (Navigator > conto > suggerimento, oppure File > Apri un conto).
4. **Commissione sull'oro**: NON leggibile via API ne' dalla specifica. Si legge da un deal chiuso sull'oro del reale (non ce n'e') oppure si chiede a BCM per iscritto, insieme alle condizioni del bonus.

## Cosa NON si puo' misurare in sola lettura
- **Slippage dell'oro sul reale**: serve almeno un deal sull'oro con prezzo richiesto e prezzo eseguito. Senza operare non esiste (il demo non lo simula: BCM l'ha confermato; l'`ABTG_SlippageLogger` del reale ha solo indici).

## Perche' non una riga di installazione adesso
Installare uno strumento (SpreadLogger su XAUUSD) significa scrivere nella cartella del terminale reale e attaccare un EA a un grafico: va fatto con il cancello completo (agente di giudizio + cancello meccanico). In questa esecuzione gli agenti di controllo non esistono e `pwsh` per provare la sintassi non c'e'. Resta pronta in repo solo la riga di identificazione dei terminali, di sola stampa: `backtest_pipeline/righe/RIGA_IDENTIFICA_TERMINALI_VPS.txt` (cancello meccanico: nessun difetto; parser NON eseguito).
