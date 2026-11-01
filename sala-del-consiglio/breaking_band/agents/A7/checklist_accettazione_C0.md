# Checklist di accettazione finale per C0 — "verificato localmente" (A7), versione 2
Un risultato del test Breaking Band puo dirsi **verificato localmente** SOLO se tutte le voci B sono SUPERATO con evidenza allegata (percorso + output letterale). NON_CONCLUSIVO o non eseguito = NON superato. Riferimenti V = `piano_verifica.md` (stato aggiornato li).

## A. Prerequisiti (prima di guardare i numeri)
- [ ] B  Hash sha256 dei tre documenti congelati registrato da C0 PRIMA del run (V14) — documenti verificati da A7 il 01/11: coincidono con HASH_DOCUMENTI.
- [ ] B  **Hash del CODICE** (signals.py, engine.py, params.py, run_test.py) registrato prima del run (V14, CK-32). Non ancora fatto.
- [ ] B  sha256 dei 4 CSV = HASH_DATI.txt e righe = audit A3 (V18) — richiede autorizzazione di C0 (solo hashing).
- [ ] B  Decisione di C0 su Q1 (armamento prima della barra 200: A4 arma da t>=200, A7 da indicatori pronti) PRIMA dell'hash del codice; vedi `domande.md`.
- [ ] B  Convenzioni di simulazione (specifica sez. 6) coincidenti col ricalcolatore (piano sez. 2): fill target al livello, mkt, target oltre ingresso, gap 180, spread 0.

## B. Correttezza del motore e dei segnali
- [ ] B  Nessun look-ahead: troncamento (V01), perturbazione (V02) per ogni variante x TF (H1, M30) + ispezione (V03). Sintetico gia SUPERATO; ispezione NON eseguita; estratto reale dopo autorizzazione.
- [ ] B  Simmetria rialzo/ribasso: segnale (V04, SUPERATO sintetico) e motore (V05, da eseguire).
- [ ] B  Spread long e short (V06), stop prima del target (V07), ingresso alla barra dopo (V08): SUPERATI su sintetico con ricalcolo indipendente (1185 trade + 60 stop-first iniettati); da ripetere sul log reale (V06-V08 DOPO RUN).
- [ ] B  Nessun segnale con trade aperto (V09), imbuto riconciliato (V10) per ogni cella — DOPO RUN.
- [ ] B  Test di A4 rieseguiti da A7 (V20): eseguiti, OK (30+31+11); qualita dei test da ispezionare.
- [ ] B  Pattern piantati (V22) e reimplementazione indipendente (V21): sintetico SUPERATO (segnali identici); divergenza Q1 da chiudere; CONFRONTO REALE dopo autorizzazione, con zero divergenze non spiegate.
- [ ] B  Placebo su passeggiata casuale |z|<=3 (V23) — DOPO RUN.
- [ ] S  Test di mutazione sulla copia del motore (V19) — non eseguito su A4.

## C. Riproducibilita e ricalcolo
- [ ] B  Due esecuzioni complete = stesso `sha256_risultati` (V11).
- [ ] B  20 trade per cella (seme dal sha256 del LOG_TRADE) ricostruiti a mano e con codice, 20/20 coincidenti; livelli stop/target riverificati da M1 (V12).
- [ ] B  n, vincite, PF di ogni cella ricalcolati sull'intera popolazione e identici (V13).

## D. Completezza e onesta del rapporto
- [ ] B  **16 celle = {CONT, INV} x {H1, M30} x 4 periodi** + totali + pooled H1/M30 + T6 (Sa, Sb, Sc, Sd, Se20, Se50, Sf, Sg) + B1/B0/B2 + T1-T9 tutti riportati, anche con n=0; M15 assente (V16).
- [ ] S  Chiusure FINE_DATI / MKT / TARGET_OLTRE_INGRESSO / spread 0 quantificate (V17).
- [ ] B  Hash criteri nel rapporto = congelato = attuale; ordine temporale (V14, V15).
- [ ] B  Ogni numero del rapporto riconducibile a una tabella/log; clausole obbligatorie Parte C dei criteri (XAUUSD fuori scopo della Guida, fonte "versione didattica", N e potenza, parole vietate) presenti.
- [ ] B  Se un controllo e FALLITO e il codice corretto: tutti i controlli rieseguiti, correzione e numeri prima/dopo riportati.

## E. Esito
- **VERIFICATO LOCALMENTE**: tutte le voci B = SUPERATO e le S o superate o dichiarate come limite.
- **NON VERIFICATO**: almeno una voce B FALLITA o non conclusa. Vieta ogni verdetto sul vantaggio (criteri Parte A).
- Formula nel rapporto: "Verificato localmente: motore e segnali controllati con ricalcolo e reimplementazione indipendenti su dati sintetici e storici; NON prova un vantaggio statistico, non e validato fuori campione ne su conto demo/reale."

## F. Cosa "verificato localmente" NON significa
Non dimostra che la strategia funzioni; non copre esecuzione reale (slippage, requote, swap), news, EURUSD, spread FTMO, regole prop; non verifica la fedelta della specifica alla Guida Operativa ufficiale (fonte "versione didattica").
