# Preset per l'ora solare: cosa cambia, dove, come tornare indietro (04/11/2026)
Regola: server BCM = GMT+1 fisso; d'inverno = ora italiana, d'estate 1 ora indietro (CLAUDE.md). Valori ricostruiti da cio che GIRA (CODA_08 del 04/11, terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo 50503392). Ipotesi: l'ora ITALIANA voluta e quella messa d'estate (+1 ora al server). Tutti i vecchi valori letti coincidono con quelli attesi.

| EA | Grafico | Magic | Input (estate -> inverno) |
|---|---|---|---|
| MaxMinNotte | XAUUSD | 770402 | BoxStartHour 23->0, BoxEndHour 4->5, PlaceHour 7->8, EntryCutoffHour 8->9, CloseHour 17->18 |
| Nasdaq_Apertura_US | NASUSD | 770250 | SessionHour 14->15, CloseHour 20->21 |
| Dow_Apertura_US | U30USD | 770202 | SessionHour 14->15, CloseHour 17->18 |
| ORB_Ottimizzato | XAGUSD, U30USD | 770611 | RangeStartHour 14->15, RangeEndHour 14->15, EndHour 21->22 |
| EasyTrend | CHFJPY, GBPUSD | 772421, 772422 | HourStart 8->9, HourEnd 18->19 |
| PostNews | USDJPY | 771203 | ActionHour 14->15, ExpiryHour 17->18 |
| PostNews | EURJPY | 771201 | ActionHour 15->16, ExpiryHour 18->19 |
| PostNews | EURUSD | 771202 | ActionHour 19->20, ExpiryHour 20->21 |
Gia a ora solare (non toccati): DAX_Apertura_EU, MaxMinNotte_DAX_Short_Ottimizzato. Non cambiano: GapContinuation 225JPY (Asia, orario fisso rispetto a GMT), SuperWave/SupRev/SupertrendReversal (0-24).
**Non toccato, da decidere:** PostNews `InpFridayCloseHour=21` / `InpFridayCloseMin=50` (chiusura del venerdi: legata alla fine sessione del broker in ora server, non all'ora italiana; il GTP stampa oggi la sessione del venerdi dell'oro come 00:05-21:50 server). Verificare prima di cambiarla.

## File
- 10 preset `.set` in `mql5/Presets/inverno/` (tutti gli input del grafico, solo gli orari cambiati; commenti in testa con il vecchio valore): per caricarli a mano da "Dati in ingresso > Carica".
- Script `backtest_pipeline/righe/ORE_SOLARI_BCM.ps1` e riga `RIGA_ORE_SOLARI_BCM.txt` (PROVA sola lettura + APPLICA con conferma scritta).
- Controllo notturno: CODA_13 (gia in coda su `lavoro`).

## Come tornare indietro
Il backup dei `.chr` originali va sul Desktop del VPS (`BACKUP_CHR_ESTATE_<data>`): con il terminale chiuso si copiano di nuovo in `MQL5\Profiles\Charts\<profilo>`. D'estate (fine marzo 2027): riapplicare con i valori inversi.

## Limiti
Script non provato su PowerShell (nessun `pwsh` qui): per questo esiste la PROVA e il backup. APPLICA modifica solo i grafici in tabella, solo se il valore attuale e quello estivo atteso, e rilegge il file per verificare.

## ESITO (04/11/2026, 09:33 ora locale del VPS)
Prova: 10 grafici trovati su 10, 0 valori diversi dall'atteso, 0 non trovati (`PRESET_ORA_SOLARE_ESITO/prova_2026-11-04.txt`). APPLICA: terminale BCM chiuso da Claudio, 10 `.chr` modificati, rilettura OK su tutti e 10 (`applica_2026-11-04.txt`). Backup dei `.chr` originali sul Desktop del VPS: `BACKUP_CHR_ESTATE_20261104_0933`. Profilo attivo: ORO. Primo tentativo (09:25) fermato dallo script: errore mio (CR nel nome profilo) e terminale acceso: niente scritto. Da fare: riavvio del terminale e controllo delle sedie; CODA_13 (03:30 del 05/11) rilegge i `.chr` e deve dire OK sui 10 grafici. Resta da decidere `InpFridayCloseHour=21/Min=50` di PostNews (non toccata).
