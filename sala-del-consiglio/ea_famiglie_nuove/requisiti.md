# Requisiti di accettazione (scritti prima)
R1. Ogni affermazione sul codice ha file:riga; senza riga = INFERENZA o DA_VERIFICARE.
R2. Per ogni EA sono controllati e dichiarati SI/NO/NON_DETERMINABILE: lettura della barra in formazione (iOpen/iHigh/iLow/iClose o CopyBuffer con partenza 0 usati per decidere), orari in input vs ora legale, distanze in punti fissi vs scalate con ATR, controllo di nuova barra, stop minimo/distanza minima del broker, spread nel filtro, gestione ordine rifiutato, magic/commento, uso di dati futuri.
R3. A6 ricontrolla a campione (almeno 2 riga per EA, almeno 25 totali) le citazioni file:riga e le classificazioni A/B/C di A1-A5; ogni citazione errata e' un fallimento da riportare.
R4. Ipotesi di miglioramento: criterio di accettazione numerico e previsione in probabilita scritti prima; nessuna promessa di PF.
R5. Nessun EA classificato A) senza che i difetti "falsa i test" siano elencati e risolvibili senza cambiare la logica di ingresso.
R6. Report finale (`final/REPORT.md`, scritto da C0): tabella 14 righe, 5 righe di sintesi, limiti dichiarati.
