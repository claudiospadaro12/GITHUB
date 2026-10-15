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

## 3. Il minimo dell'oro (CSV M1 BCM esportato da Claudio, `data/prezzi/XAUUSD_M1_BCM_2026-09-28_30.csv`, 4.032 barre 28/09 00:00 - 30/09 21:36, ora server) [MISURATO]
- Controllo del dato: la barra 15:46-15:47 del 28/09 passa da 4.119,04 a 4.116,75: coincide col prezzo di stop out del tester (4.119,05).
- **Minimo fra 28/09 15:47 e 30/09 07:52: 4.110,83 il 28/09 alle 15:57** (28/09 low 4.110,83; 29/09 low 4.113,40 alle 02:00; 30/09 low 4.165,63 alle 06:18). Massimo nella finestra 4.188,28; il prezzo NON torna all'entrata media del cesto (4.240,09).
- Soglia di stop out col margine del reale: 4.078,7. **Il minimo e' 31,9 USD sopra: nessuno stop out.** Equity minima 2.091 EUR, livello di margine minimo **205,6%** (contro 42,8% del tester).
- Perdita flottante del cesto: -6.367 al minimo (15:57), **-2.435 alle 07:52 del 30/09** (close 4.190,66), -3.494 alle 04:01 del 02/10 (4.169,14).
- **Differenza rispetto al tester (-5.962 realizzati)**: **+3.527 EUR** marcata alle 07:52 del 30/09; +2.468 alle 04:01 del 02/10; swap long -98,78 USD/lotto/notte x 0,57 lotti (circa -50 EUR a notte, mercoledi' x3). Sono valori FLOTTANTI: l'EA avrebbe agito ancora sul cesto [NON SIMULATO].
- Settembre del tester -2.505 -> circa **+1.020** marcato al 30/09 07:52 (circa +920 dopo lo swap).
- 🔴 Ma il drawdown d'equity del giorno: **-6.367 EUR flottanti al minimo = 75% del saldo di 8.458**; su 100k a lotto 0,01 sarebbero -6,4%, oltre il limite giornaliero FTMO -5% del nostro piano; sul reale da 7.500 sarebbero -85%.
- Restano NON calcolabili i giorni 1-27 (blocchi di margine assenti nel reale) e agosto.

## 4. Spread dell'oro: GIA' misurato sul feed BCM (nessuna installazione sul reale) [MISURATO sul demo, stesso server]
- `ABTG_SpreadLogger` sul demo 50503392 (server `BCMMarkets-Server`, lo stesso del titolo finestra del reale 10105439), campionamento ogni 5 s, 04-11/09, 5 giornate per ora: **XAUUSD mediana 0,18-0,27 USD** (notte 0,25-0,27; giorno 0,18-0,21), **P95 0,22-0,29**, max normale 0,28; due spike: **2,88 USD** (ora 13 server) e **1,48** (ora 21). Dati: `data/spread_vivo/SPREAD_VIVO_2026-09-12_*`.
- CSV M1 BCM del 28-30/09 (campo SPREAD della barra): mediana 0,21; P95 0,27; max 0,29; nessuna barra >= 1 USD (la barra porta lo spread di chiusura, non il massimo).
- A mediana 0,21 USD il giro costa circa 21 USD per lotto (circa 19 EUR) contro 4 USD di commissione: lo spread pesa circa 5 volte la commissione. Gia' dentro il tester (tick reali).
- NON verificato: che il REALE abbia lo stesso spread del demo (stesso nome server, ma non lo stesso conto). Controesempio economico, senza installare niente: screenshot simultaneo della colonna Spread di XAUUSD nei due terminali (10105439 e 50503392) a due orari. La riga di installazione del logger sul reale NON e' stata preparata: `RIGA_SPREADLOGGER.ps1` ha il bersaglio 50503392 scritto dentro (`$CONTO_PICCOLO`) e un'altra destinazione richiede il cancello completo (non disponibile in questa esecuzione).
