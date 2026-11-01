# Checklist di accettazione finale per C0 — "verificato localmente" (A7)

Un risultato del test Breaking Band puo dirsi **verificato localmente** SOLO se tutte le voci B sono SUPERATO con evidenza allegata (percorso del file + output letterale). NON_CONCLUSIVO o non eseguito = NON superato. Riferimenti V = `piano_verifica.md`.

## A. Prerequisiti (prima di guardare i numeri)
- [ ] B  Criteri di accettazione e previsioni in probabilita scritti e **hash sha256 registrato prima del run** (V14, R005). Hash riportato nel report finale.
- [ ] B  Interfaccia di A4 disponibile (funzione di segnale, log trade completo con schedule dei target, contatori dell'imbuto) oppure adattatore di A7 dichiarato.
- [ ] B  Convenzioni di simulazione (spread, gap, barra di ingresso, chiusura forzata) dichiarate per iscritto e confrontate con quelle del ricalcolatore (piano sez. 2).
- [ ] B  Dati: sha256 dei 4 CSV registrati; righe = audit A3 (V18).

## B. Correttezza del motore e delle regole
- [ ] B  Nessun look-ahead: troncamento (V01), perturbazione (V02), ispezione (V03) tutti SUPERATI per ogni variante x timeframe.
- [ ] B  Simmetria rialzo/ribasso del segnale (V04) e del simulatore (V05), o asimmetria dichiarata da A2 e verificata come tale.
- [ ] B  Spread pagato su long e short, importi e unita verificati (V06).
- [ ] B  Stop prima del target nella stessa M1 (V07), anche su caso sintetico passato al motore.
- [ ] B  Ingresso alla barra successiva con prezzo ricalcolato dalle M1 (V08).
- [ ] B  Nessun segnale accettato con un trade aperto (V09).
- [ ] B  Test di correttezza di A4 rieseguiti da A7 da zero e superati (V20).
- [ ] S  Test di mutazione: ogni difetto iniettato e rilevato (V19); altrimenti il limite e scritto nel report.

## C. Riproducibilita e ricalcolo
- [ ] B  Due esecuzioni complete = stesso sha256 dei risultati (V11).
- [ ] B  20 trade per cella ricostruiti a mano e con codice indipendente, 20/20 coincidenti con il motore (V12); livelli stop/target riverificati da M1.
- [ ] B  n, vincite e PF di ogni cella ricalcolati sull'intera popolazione e identici (V13).
- [ ] B  Imbuto coerente e riconciliato per ogni cella (V10).

## D. Completezza e onesta del report
- [ ] B  16 celle (CONT/INV x H1/M15 x 2013, 2018, 2020, 2025-26) tutte riportate, anche con n=0 o PF non definito; nessuna variante omessa (V16).
- [ ] S  Chiusure forzate e fine dati dichiarate e incluse (V17).
- [ ] B  Hash dei criteri nel report = hash congelato = hash attuale; nessuna soglia cambiata dopo il run (V14); mtime/commit coerenti (V15, evidenza debole).
- [ ] B  Ogni numero del report finale riconducibile a un CSV/log; nessun dato inventato; interpretazioni di A2 e limiti (Guida Operativa 11 mancante, nessun dato EURUSD, confronti multipli) dichiarati.
- [ ] B  Se un controllo e stato FALLITO e il codice corretto: tutti i controlli rieseguiti, correzione e numeri prima/dopo riportati.

## E. Esito
- **VERIFICATO LOCALMENTE**: tutte le voci B = SUPERATO e le voci S o superate o dichiarate come limite nel report.
- **NON VERIFICATO**: almeno una voce B FALLITA o NON_CONCLUSIVA. I numeri non vanno presentati come risultato; il report dice quale controllo manca.
- Formula da usare nel report: "Verificato localmente: motore e statistiche controllati con ricalcolo indipendente su dati storici sintetici e reali; NON e una prova di vantaggio statistico, non e validato fuori campione ne su conto demo/reale."

## F. Cosa "verificato localmente" NON significa
Non dimostra che la strategia funzioni; non copre l'esecuzione reale (slippage, requote, swap), le news, ne i dati EURUSD degli esempi; non verifica la fedelta di A2 alla Guida Operativa 11 (mancante).
