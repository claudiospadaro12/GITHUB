# 📊 ANALISI DEL CSV TRADEEXPORTER (VPS, conto piccolo) — 27/08/2026 mattina

_Fonte: `ABTG_Trades.csv` scaricato da Claudio dal Common\Files del VPS
(1.230 righe-posizione, 30/03/2026 → 26/08/2026 sera, con open_time,
close_time, magic, commento, motivo di chiusura). È il file che dà
l'attribuzione per-famiglia **precisa** — con le DURATE, che agli
statement mancavano (il famoso `open_time`). Conto: il DEMO PICCOLO
50503392 (volumi coerenti); il 100k non è in questo file._

## 1) 🔴 IL NUMERO PIÙ IMPORTANTE DEL FILE — e va detto senza giri

| Comparto | posizioni | netto |
|---|---:|---:|
| **Trading MANUALE (magic 0 / senza strategia)** | 661 | **−18.706,94 €** |
| Era sperimentale EA (BULGE ecc., mar-giu, già chiusa) | ~300 | ≈ −1.100 € |
| **Flotta EA attuale (dal 20/07)** | ~270 | **≈ +900 € in utile** |

La peggior giornata del comparto manuale: **−12.164,52 €** (una sola
giornata). La flotta attuale, nello stesso conto, è **in utile** nel suo
primo mese abbondante di vita.

**La lettura onesta**: questo file è la dimostrazione MISURATA della
scelta di Claudio ("non ho altri obiettivi se non gli expert"). Il
comparto discrezionale ha bruciato in 4 mesi più di quanto la flotta
abbia mai rischiato in un giorno; gli esperimenti EA vecchi sono stati
chiusi in perdita PICCOLA e controllata (il metodo li ha spenti); la
flotta disciplinata è verde. **Sul conto prop il manuale non esisterà:
è già la policy — questo file dice quanto vale quella policy.**

## 2) 📈 I conteggi per famiglia (flotta attuale, verso il cancello 1)

Confermati e raffinati rispetto agli statement: Aperture DAX resta la
famiglia in corsia MERITO (BUY −266,60 su 15 pos + SELL −392,22 su 9 +
OTT −88,42; **RETEST +64,76 su 6: sempre verde**). ORB verde (+295 BUY /
+56 SELL su 20 pos). MaxMinNotte DAX +122,65 (4 pos). EMA200 DOW +93,73
(7 pos). Le famiglie EasyTrend/STREV/Nightly: campioni 1-5 pos, tutti
piccoli. **Nessuna famiglia nuova sopra la soglia 20 op oltre a quelle
già note** (Aperture DAX, ORB).

## 3) ⏱️ LE DURATE — il dato per la regola dei 2 minuti (Alpha)

Quota di posizioni chiuse **sotto i 2 minuti**, per le famiglie
d'apertura: Apertura Marco 80% · DAX Apertura OTT 70% · Nasdaq 50% ·
DAX Apertura BUY 40% · SELL 33% · ORB BUY 20%. Le famiglie
swing/notturne: 0%. **Su una prop con durata minima 2 minuti (Alpha) le
famiglie d'apertura sono fuori legge una volta su 2-5**: se la risposta
di Alpha confermerà la regola dura, o si escludono le aperture dal
conto Alpha, o Alpha esce dalla classifica. Il dato ora è per-famiglia,
non più una media di flotta (15,2%).

## 4) 🗒️ Note

- `close_reason` disponibile (sl/tp/manuale): le chiusure "manuale" nel
  comparto EA sono rare — buon segno di disciplina anche operativa.
- Il file copre solo il conto piccolo: per il 100k serve lo stesso
  export (TradeExporter sul terminale del 100k — candidato ai lavori di
  weekend, NON oggi che è Jackson Hole).
- Questo CSV chiude di fatto il **terzo mandato open_time** per il
  forward (le durate ora ci sono); resta aperto per i BACKTEST
  (ExportTrades degli EA scrive solo close_time).
