# Note di progetto — DA RICORDARE SEMPRE

## FUSO ORARIO BCM (regola fissa)
**Il server BCM è 1 ORA INDIETRO rispetto all'ora italiana** (in questo periodo dell'anno).
- Ora italiana − 1 = ora server BCM.
- Quindi:
  - DAX apre **09:00 IT = 08:00 server BCM**
  - Nasdaq apre **15:30 IT = 14:30 server BCM**
- Negli EA/`.ini` `InpSessionHour` va SEMPRE messo in ORA SERVER (quindi 8 per il DAX, 14:30 per il Nasdaq).
- Verifica rapida di un CSV di risultati: colonna `InpSessionHour` deve essere **8** (DAX) / **14** (Nasdaq). Se è 9 / 15 → ora sbagliata, cestinare.

## Contesto
- Conto DEMO BCM 50503392, tipo HEDGING.
- Sviluppo sul branch `claude/creating-agents-SgGpD`.
- Ottimizzazioni/backtest sul PC di backtest; gli EA girano in forward sul VPS.
- Regola EA: gli `_Ottimizzato` girano in parallelo agli originali (magic diversi), mai sostituirli.
