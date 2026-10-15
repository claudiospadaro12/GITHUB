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

## 2. Quanto avrebbe cambiato il margine del reale -- calcolo sul 28/09 del tester (stessi trade, solo il margine diverso) [DERIVATO]
Dati: 13 deal di stop out del 28/09 15:47 (prezzo di liquidazione 4.119,05; 0,57 lotti di buy; entrata media 4.240,09; perdita di liquidazione -5.961,83 EUR; saldo prima 8.457). Le entrate dei 13 buy sono ricostruite da profitto/(volume x 86,41).
- **Controllo del modello**: con il margine del tester (8.580,52 EUR/lotto) il modello prevede lo stop out a 4.118,03; il tester l'ha fatto a 4.119,05 (errore 1 USD).
- **Con il margine del reale (1.784,58 EUR/lotto)** lo stop out scatterebbe a **4.078,7** (40 USD piu' in basso; perdita flottante 7.949 invece di 5.962).
- Perdita flottante del cesto a vari prezzi: 4.119 -> -5.962; 4.150 -> -4.437; **4.190 -> -2.467**; 4.220 -> -990; 4.250 -> +488.
- Ancore di prezzo note dopo il 28/09 15:47: 30/09 07:52 entrata MAXMIN ORO a **4.190,00** (demo); sessione del 30/09 07:52-15:37: min 4.147,49, max 4.219,26; 02/10: min 4.125,22. **Il minimo fra 28/09 15:47 e 30/09 07:52 NON e' nel repo**: decide il segno.
- **Se l'oro NON e' sceso sotto 4.078,7**: niente stop out; marcato a 4.190 il cesto vale -2.467 contro -5.962 realizzati: **+3.495 EUR** (prima dello swap long ~ -100 EUR e di cio' che l'EA avrebbe fatto dopo); il mese di settembre passerebbe da -2.505 a circa **+990**.
- **Se l'oro e' sceso sotto 4.078,7**: stop out a equity circa 509 EUR contro i 2.495 finali del tester: circa **-1.990 EUR**.
- Agosto (05/08 12:59) NON e' ricostruibile allo stesso modo: lo stop out chiude 6 buy (0,27 lotti) ma c'erano anche sell vivi (0,46) e il conto e' finito a 1.936,71: il modello a una sola gamba non riproduce il prezzo (previsto 4.087 contro 4.191 reale).
- **NON calcolabile da questo report**: la differenza di comportamento dell'EA. Con 4,8 volte meno margine i blocchi `margin level too low` (migliaia dal 01/09 02:32) non scatterebbero, quindi ingressi e cesti dei giorni 1-27 sarebbero diversi.
