# Note di progetto — DA RICORDARE SEMPRE

## FUSO ORARIO BCM (regola fissa) — AGGIORNATA 04/11/2026
**Il server BCM e a GMT+1 FISSO (non cambia con l'ora legale).** Quindi rispetto all'ora italiana:
- **ORA LEGALE italiana (fine marzo - fine ottobre): il server e 1 ORA INDIETRO.** DAX apre 09:00 IT = **8** server; Nasdaq/Dow cash 15:30 IT = **14:30** server.
- **ORA SOLARE italiana (fine ottobre - fine marzo): il server e UGUALE all'ora italiana.** DAX apre 09:00 IT = **9** server; Nasdaq/Dow cash 15:30 IT = **15:30** server.
- Prova (04/11/2026): Market Watch BCM = ora italiana (confermato da Claudio); log GTP "Broker time 08:43 = GMT+1"; NFP 06/11 alle 14:30 nel log. Sui dati M1 del DAX (D30EUR 2025) il picco di volumi dell'apertura e a 09:00 server in inverno e a 08:00 server in estate.
- Negli EA/`.ini` `InpSessionHour` va SEMPRE messo in ORA SERVER **e va cambiato due volte l'anno** (fine marzo e fine ottobre, e di nuovo quando gli USA cambiano ora per le aperture Nasdaq/Dow: tre settimane di scarto tra Europa e USA). Controllare il cambio d'ora ogni volta (Market Watch vs ora italiana).
- **Backtest**: lo storico BCM ha la stessa regola: un'esecuzione su un anno intero con un solo `InpSessionHour` (es. 8 per il DAX) e sbagliata in inverno (l'EA parte 1 ora prima dell'apertura). Per i test sul DAX/Nasdaq separare estate e inverno o impostare l'ora per periodo.
- Verifica rapida di un CSV di risultati: colonna `InpSessionHour` coerente con il periodo del test (DAX 8 in estate / 9 in inverno; Nasdaq 14:30 in estate / 15:30 in inverno). Un anno intero con un solo valore: segnare il limite nel referto.
- FTMO: server = ora italiana + 1 (confermato 02/11/2026, indipendente da questa regola).

## Contesto
- Conto DEMO BCM 50503392, tipo HEDGING.
- Sviluppo sul branch `claude/creating-agents-SgGpD`.
- Ottimizzazioni/backtest sul PC di backtest; gli EA girano in forward sul VPS.
- Regola EA: gli `_Ottimizzato` girano in parallelo agli originali (magic diversi), mai sostituirli.
