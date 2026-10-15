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

## 1. Prima lettura: Specifiche di XAUUSD (screenshot di Claudio, 15/10 21:25)
🔴 Lo screenshot NON mostra il numero di conto: attribuzione al terminale 10105439 (PID 7528, `C:\BCM_Reale`) NON verificata [da confermare con titolo finestra o riga conto].
- XAUUSD, Gold vs US Dollar, 100 oz, **Forward contract**, calcolo Forex, 2 cifre, spread **fluttuante**, livello degli stop **50** punti, margine e profitto in USD.
- **Commissione: 2 USD per lotto per deal (in e out), fascia 0-1000 lotti** -> 4 USD a giro, circa 3,6 EUR: coerente con il tester (3,42-3,71) e col demo (3,84-4,00).
- **Margine**: tasso 10000 «valore nozionale», **circa 1.784,58 EUR per lotto** (buy e sell, iniziale e mantenimento). Il tester (R114, 27/08) aveva letto **8.580,52 EUR per lotto**: fattore **4,8** [DERIVATO]. Con prezzo oro circa 4.000 e EURUSD circa 1,117 la leva implicita e' circa 1:200 [DERIVATO, da confermare sulla riga del conto].
- Swap in punti: **long -98,78, short +19,28** (circa 98,78 USD per lotto a notte, mercoledi' x3).
- Esecuzione Market, filling **FOK e IOC** (niente Return), volume min/step 0,01, max 100, GTC.
- Sessioni (ora server): lun-gio 00:00-21:55 e 23:05-24:00, ven 00:05-21:50, dom 23:10-24:00.
- Conseguenza: gli stop out del tester (05/08, 28/09) e i blocchi `margin level too low` dell'EA nascono dal margine del tester (4,8 volte quello mostrato qui): il tester non risponde da solo a «regge sul reale»; con meno margine l'EA bloccherebbe meno e i cesti potrebbero scendere piu' in profondita' [IPOTESI, non simulata].
- Mancano: spread vivo a piu' orari, riga del conto con leva, e la stessa finestra Specifiche sul demo 50503392 per il confronto.
