# Prompt per Claude in Chrome: costi e condizioni di trading FTMO, con file zip (11/11/2026)

Uso: Chrome aperto su https://ftmo.com/en/ con l'estensione Claude attiva e il permesso concesso a ftmo.com. Incolla il prompt nel pannello laterale. Sola lettura, nessun login. Scopo: sostituire le mie ipotesi di costo (36 EUR/lotto oro, 4 EUR/lotto forex) con i dati FTMO. Non decide acquisti.

```
Sei in sola lettura sul sito ufficiale FTMO (ftmo.com, versione inglese /en/). Regole ferme: NON accedere a nessun account, NON inserire dati, NON cliccare Buy / Start / Checkout / Free Trial / Login, NON compilare form. Solo pagine pubbliche. Non inventare nulla e non completare a memoria: se una pagina non lo dice scrivi "NON TROVATO". Ogni dato porta: valore, FRASE ESATTA tra virgolette (o riga della tabella), URL, data di aggiornamento della pagina se mostrata.

OBIETTIVO: raccogliere TUTTE le condizioni di trading che incidono sul costo e sul rischio di EA su oro e forex, in particolare XAUUSD ed EURUSD.

PAGINE DA LEGGERE (e quelle che ti sembrano collegate):
- La pagina Symbols / Instruments (cerca da ftmo.com "Symbols", "Instruments", "Trading conditions") e ogni tabella: contract size, margine, leva Standard e Swing, commissione, orari di trading, lotto minimo / massimo / passo.
- /en/faq/what-are-the-account-specifications/ e le FAQ su spread, commissioni, swap, slippage, leva, orario del server, orario di mercato, rollover, weekend.
- Tutti i "Trading Update" del blog (ftmo.com/en/blog/trading-updates/...) degli ultimi 18 mesi: elenca date e cosa e cambiato su spread, commissioni, leva, swap, news, XAUUSD.
- Gli articoli "Updated Trading Conditions for the Dollar Index (DXY) and XAUUSD", "What is a swap and for whom is it important?", "Holding trades over the weekend?", "What's consuming all your profits?".
- Regole su news (XAUUSD, DXY), posizioni nel weekend, limiti di ordini/posizioni, EA permessi e pratiche vietate (solo se cambiano costi o rischio).

DATI DA ESTRARRE (tabelle, non frasi generiche)
A. Per XAUUSD, EURUSD, GBPUSD, USDJPY, USDCHF, AUDUSD, NZDUSD, USDCAD, EURGBP, EURJPY, GBPJPY, AUDJPY, EURCHF (e ogni altra coppia forex che trovi): contract size, commissione per lotto per lato e come e espressa (USD per lotto oppure % del valore), leva Standard e Swing, margine, lotto min / max / passo, spread tipico o medio SE la pagina lo dichiara, swap long e swap short SE dichiarati, giorno del triplo swap, ora del rollover.
B. Orari: orario del server MT5 (GMT+? e cambio ora legale), orario di apertura e chiusura di XAUUSD e delle coppie forex, pausa giornaliera dell'oro, chiusura del weekend.
C. Cambiamenti nel tempo: per ogni "Trading Update" data, strumento, valore prima e dopo (commissione, spread, leva, swap).
D. Restrizioni che toccano un EA: finestre news su XAUUSD/DXY (minuti, quali eventi, cosa conta: apertura, chiusura, modifica SL/TP, ordini pendenti), limiti di ordini/posizioni aperte e di richieste al giorno, regole su slippage e requote.
E. Come FTMO calcola la perdita giornaliera e totale (equity, commissioni e swap inclusi o no, ora di azzeramento).
F. Cosa NON e pubblico (richiede il login o la specifica del simbolo nel terminale MT5): elencalo in una sezione "DA LEGGERE A MANO NEL TERMINALE", con la lista dei dati mancanti e come trovarli (Market Watch > clic destro sul simbolo > Specifiche).

OUTPUT: FILE E ZIP
1. Crea questi file di testo (Markdown, UTF-8): 
   00_INDICE_pagine_lette.md (URL, titolo, data se mostrata, esito: letta / non si apre / richiede login),
   01_costi_per_simbolo.md (tabella A, una riga per simbolo, colonne: simbolo | contract size | commissione | leva Std/Swing | margine | lotto min-max-passo | spread dichiarato | swap long/short | URL | stato CHIARO/AMBIGUO/NON TROVATO),
   02_orari_e_server.md (B),
   03_storico_modifiche.md (C),
   04_restrizioni_EA_news_ordini.md (D),
   05_calcolo_perdita_giornaliera.md (E),
   06_da_leggere_nel_terminale.md (F),
   07_estratti_testuali.md (le frasi esatte, una per punto, con URL),
   99_DOMANDE_PER_IL_SUPPORTO.md (tutto cio che e AMBIGUO o NON TROVATO, come domande da scrivere al supporto FTMO).
2. Mettili in una cartella FTMO_COSTI_2026-11-11 e comprimila in FTMO_COSTI_2026-11-11.zip (Salva nella cartella Download). Il file deve pesare meno di 10 MB.
3. Se non puoi creare file o uno zip: scrivi ogni file nella risposta, uno dopo l'altro, in blocchi che iniziano con la riga "=== FILE: nome_del_file ===" e finiscono con "=== FINE ===", cosi li assemblo io. Dillo all'inizio.
4. In fondo alla risposta: elenco di cio che non hai potuto leggere e perche, e le differenze fra versioni del sito (en / au / altre) o fra FAQ e pagina dei simboli.
Scrivi tutto in italiano, tranne le frasi esatte che restano in inglese. Non dare consigli di acquisto, di lotto o di taglia.
```

## Dopo
Manda lo zip (o la risposta a blocchi) qui. Rifaccio il calcolo con i dati FTMO al posto dei 36/4 e segno ogni valore come LETTO / DEDOTTO. Gli swap e lo spread veri dell'oro stanno quasi certamente solo nel terminale: li legge Claudio a mano (Specifiche del simbolo).
