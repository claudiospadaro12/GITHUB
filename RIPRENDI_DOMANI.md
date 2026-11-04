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

## Da fare davanti al PC del VPS (nota del 04/11/2026, richiesta di Claudio)
1. Controllo log (scheda Experts) dopo il riavvio del terminale BCM demo 50503392: Nasdaq 15:30/21:45, MaxMinNotte box 00:00-05:59, PostNews 15:45/16:00/20:40, ORB XAGUSD; nessun errore rosso.
2. Decidere PostNews `InpFridayCloseHour=21` / `Min=50` (non toccato).
3. Decidere il reset giornaliero del Guardian sul 100k (-V3, 50504263): `InpDailyResetHour=0`.
4. `EMA200_Ombra` EURUSD: controllare nel codice se usa un'ora fissa per i livelli della notte.
5. Referto CODA_13 di stanotte (05/11, 03:30): deve dire OK sui 10 grafici.
6. Risposta di Wim su licenza UBS e AutoLoader.
7. GTP COMBO sul demo prop 50504894: pendenti, lotti e magic base 1000 senza conflitti.
Dettagli: `report/PRESET_ORA_SOLARE_2026-11-04.md`. Promemoria pianificato per le 18:00 italiane del 04/11.
