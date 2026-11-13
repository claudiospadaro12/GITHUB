# Prompt per Claude in Chrome: GIRO 4, solo ricerca Discord per autore (13/11/2026)

Perche un altro prompt: nei giri 1-3 l'autore dei messaggi senza nome in cima e stato attribuito male. La ricerca di Discord (campo "Cerca" in alto a destra) mostra il nome dell'autore su OGNI risultato, quindi evita l'errore. Questo prompt usa solo la ricerca. Incolla il blocco nel pannello laterale di Claude in Chrome. SOLA LETTURA, risposta in chat, nessuno zip.

```
Sei in Chrome con Discord aperto sul server ForexEASolutions. SOLA LETTURA: non scrivere messaggi, non mettere reazioni, non cliccare link esterni, non scaricare allegati. Non inventare: se non trovi qualcosa scrivi "NON TROVATO". Se Discord traduce in italiano, riporta il testo originale.

METODO OBBLIGATORIO: usa il campo Cerca di Discord (in alto a destra). Nei risultati ogni messaggio mostra il NOME DELL'AUTORE e la data: copia quel nome, non dedurlo dai messaggi vicini. Il solo autore valido di Wim e "Wim The Algo Trader" (NON "Digital_Wim", che e un bot). Se un messaggio e troncato clicca "mostra altro"/"Read more" o aprilo con "Vai al messaggio" e copia il testo intero. Orari in UTC (se Discord mostra l'ora locale, convertila e dillo).

PASSO 1. Cerca: from: Wim The Algo Trader  in: all-gold-eas  (data da 03/11/2026 a oggi). Scorri TUTTE le pagine dei risultati. Per ogni risultato scrivi: data e ora UTC, autore (come mostrato nel risultato), testo COMPLETO, e se e una risposta a chi (barra di risposta) e il testo del messaggio citato. Questa e la lista completa dei messaggi di Wim in all-gold-eas.

PASSO 2. Ripeti la stessa ricerca in questi canali, uno per volta: ultimate-breakout-system (e l'altro canale con lo stesso nome se esiste), share-your-performance, important-announcements, propfirm-discussion, backtesting-discussion, daytrade-pro, vps_discussion, broker-discussion, product-manuals, ea-update-notifications. Stesso formato.

PASSO 3. Ricerche per parola chiave, TUTTE con from: Wim The Algo Trader, senza limite di canale, dal 03/11/2026: strategy 5; strategy 8; license; dashboard; IPv6; WebRequest; FTMO; prop; drawdown; Combo; 3GOLD; bug. Per ogni risultato non gia riportato aggiungi la riga come sopra.

PASSO 4. Domande degli utenti a cui Wim potrebbe aver risposto (cerca la domanda, poi apri la conversazione e leggi le risposte sotto, controllando l'autore di ogni risposta):
 a) 10/11 circa 16:56 UTC, all-gold-eas: utente che chiede se i due ordini "strat 5" in parallelo del Phantom sono un bug. Riporta le risposte, in particolare quelle di Wim dell'11/11 (inizia con "you can not disable strategy 5, unless you choose trade frequency use manual strategy selection and then do NOT use Max allowed Total Drawdown for risk (but rather max ..."): testo COMPLETO fino alla fine.
 b) 13/11 circa 02:44 UTC (canale ultimate-breakout-system o all-gold-eas): utente con Gold Reaper strategia 8 che apre 5 posizioni nello stesso istante e ne chiude 4 insieme. Riporta il messaggio per intero (EA, set, broker se scritti) e tutte le risposte con autore e ora. Se non ci sono risposte di Wim scrivi "nessuna risposta di Wim al momento della lettura".
 c) important-announcements, 07/11 circa 09:02 UTC, Wim: "license invalid" sui VPS, IPv6, EA ricaricati sulla dashboard con migliore lettura degli URL (versione invariata). Testo COMPLETO e tutte le risposte sotto, e ogni messaggio di Wim in qualsiasi canale tra 07/11 e 13/11 su dashboard, license, URL, WebRequest.
 d) 11/11 e 12/11, share-your-performance: i tre messaggi di Wim troncati nel giro 2 ("If the EA knows it's going beyond the risk allotted, why let it take the...", "Yes I test at 0.01 and it says max dd is 100$ for a 10k account... But then the set has max open trades...", "we are NOT looking at individual trades. We are looking at TOTAL drawdown of the strategy, wh..."): testo COMPLETO e il messaggio a cui rispondono.

FORMATO DELLA RISPOSTA (in chat, italiano, frasi esatte in lingua originale, nessun file):
 - Sezione A: tutti i messaggi di Wim trovati, in ordine di data, uno per riga: [data ora UTC] [canale] [autore mostrato] "testo completo" (risponde a: ...) (COMPLETO / TRONCATO).
 - Sezione B: le risposte ai 4 punti del passo 4 (a, b, c, d).
 - Sezione C: cosa NON hai potuto leggere o verificare.
 - In fondo, al massimo 8 righe con cio che Wim ha detto su: strategia 5 del Phantom, strategia 8 del Reaper, riscaricare gli EA dalla dashboard, rischio per 0.01 lotti in UBS. Nessun consiglio di acquisto, lotto o taglia.
Se la risposta e troppo lunga per un solo messaggio, dividila in parti numerate (PARTE 1/3, 2/3...) senza saltare nulla.
```
