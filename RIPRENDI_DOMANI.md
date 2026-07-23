# 📌 Riprendi domani — scaricare storico + ottimizzare gli EA

Stato: gli EA sono pronti (20/20 compilano), la pipeline funziona. Manca solo
lo **storico dei prezzi** perché i backtest abbiano dati veri.
Ticker confermati: **DAX = D30EUR**, **Nasdaq = NASUSD**, **Oro = XAUUSD**.

Fai i test sul **PC FISSO** (utente Master), NON sul VPS.

## Le 4 mosse (in ordine)

**1. Ri-scarica il progetto aggiornato** (ed estrai, sovrascrivendo il vecchio):
```
https://github.com/claudiospadaro12/GITHUB/archive/refs/heads/claude/creating-agents-SgGpD.zip
```

**2. Installa lo scarica-storico** — PowerShell nella cartella `backtest_pipeline`:
```
powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1
```
Deve dire "OK! Script installato e compilato".

**3. Scarica lo storico + TICK REALI dentro MT5:**
- Apri MT5 (fisso) → Navigatore → Script → trascina `ABTG_HistoryDownloader` su un grafico.
- In `InpSimboli` incolla: `D30EUR,NASUSD,XAUUSD,EURUSD,GBPUSD,USDJPY`
- `InpScaricaTick = true` (scarica anche i tick reali → ci mette un po', e' normale).
- `InpListaSoloNomi = false` → OK. Aspetta "=== FINITO ===" (scheda "Esperti").
- Guarda le righe "TICK": ti dicono da che data BCM ha i tick reali (la profondita').
  Se "nessun tick reale disponibile" per un simbolo → dillo a Claude.

**4. Ottimizzazione a TICK REALI (scelta "B"):**
- CHIUDI MT5.
- PowerShell in `backtest_pipeline`:
```
powershell -ExecutionPolicy Bypass -File .\run_all.ps1
```
- ATTENZIONE: a tick reali e' MOLTO piu' lento → lascialo girare a lungo
  (anche una notte intera). E' voluto: backtest realistici.
- Alla fine:
```
(Get-ChildItem .\risultati_ottimizzazione\OptResults_*.csv).Count
Compress-Archive -Path .\risultati_ottimizzazione\*.csv -DestinationPath .\risultati.zip -Force
```
- Manda `risultati.zip` a Claude → lui analizza e crea gli EA `_Ottimizzato`.

## Dopo (lo fa Claude)
Analisi robusta dei risultati (no overfit) → crea gli `ABTG_*_Ottimizzato.mq5`
con i parametri migliori già dentro.
