# 🇩🇪 LA DAX APERTURA (770101) SU FTMO E SUL REALE: stessi ordini? (28/09/2026)

Fonte: i due estratti conto mandati da Claudio il 28/09 (Report Cronistorico dei Trade, MT5): FTMO `541452707`
(GER40.cash, ora server FTMO = IT+1) e reale BCM `10105439` (D30EUR, ora server BCM = IT-1 d'estate, quindi
**FTMO = BCM + 2 ore**). Giornali del reale: `backtest_pipeline/coda/referti/CODA_09_*` del 25-26/09. Sola lettura.
Lo SPREAD non e' negli estratti (niente bid/ask): qui si misura solo lo SLIPPAGE. Nessuna taglia proposta.

## 1. Risposta: NO, non sono identici. Stesso EA, stessi giorni, tre esiti diversi su quattro

| giorno | reale BCM `10105439` (ora BCM) | FTMO `541452707` (ora FTMO = BCM+2) | uguali? |
|---|---|---|---|
| 21/09 | buy limit 09:05:30 @25.510,4 -> **scaduto** 11:05 | buy limit 11:05:32 @25.517,84 -> **scaduto** 13:05 | ✅ stesso ordine, stesso esito (2 secondi di scarto) |
| 22/09 | buy limit **09:56:34** @25.622,9 -> **eseguito** 7 s dopo, chiuso 11:13 al trailing **+10,17 EUR** (+101 punti) | buy limit **12:43:05** (= 10:43 BCM) @25.630,54 -> **scaduto** 14:43, mai toccato | 🔴 **NO**: FTMO ha visto la rottura **47 minuti dopo** e ha perso il movimento intero |
| 24/09 | buy limit 14:17:39 @25.392,1 -> eseguito **14:23:03**, chiuso 14:35:00 al trailing (+3,0 punti, **+0,60 EUR**) | buy limit 16:17:03 (= 14:17:03 BCM, 36 s prima) @25.392,54 -> eseguito **16:35:18** (= 14:35:18 BCM), chiuso 43 s dopo al trailing (+6,5 punti, **+69,66 EUR**) | 🟠 stesso ordine, **esecuzione 12 minuti dopo**, stesso finale (trailing) |
| 25/09 | **nessun ordine DAX** (giornale del reale: 1 sola riga d'ordine, ed e' l'ORB su EURAUD) | buy limit 11:28:40 @25.468,24 -> eseguito 12:27:10, chiuso 17:02 **allo stop pieno: -1.552,80 EUR** | 🔴 **NO**: FTMO ha operato e perso lo stop, il reale non ha nemmeno piazzato |

Bilancio della settimana comune 21-25/09: reale **+10,77 EUR** su 2 operazioni (0,1-0,2 lotti); FTMO **-1.483,14 EUR** su 2
operazioni (10,7-19,9 lotti). La differenza di taglia e' 2,00% contro 0,65% su conti diversi: attesa. La differenza
di **quali giorni si e' entrati** no.

## 2. Perche' divergono (MISURATO dove si puo', INFERITO dove no)
- **I due broker quotano prezzi diversi** (GER40.cash contro D30EUR): 21/09 +7,4 punti FTMO, 22/09 +7,6, 24/09 +0,4
  [MISURATO dai limiti]. Lo scarto **non e' costante**: le candele M5 chiudono a valori diversi, quindi la regola
  "chiusura sopra il massimo del range + buffer" scatta in momenti diversi. Il 22/09 e' il caso pieno: sul BCM la
  rottura e' sulla candela delle 09:55 (ordine alle 09:56:34, eseguito 7 s dopo), su FTMO solo alle 12:40 FTMO
  (= 10:40 BCM), e a quel punto il retest non e' piu' tornato [MISURATO sugli orari].
- **Il 25/09 sul reale non c'e' nessuna riga della DAX** (ne' ordine ne' errore): o la rottura non c'e' stata sul feed
  BCM, o l'EA non era sul grafico. **[NON MISURATO]**: la sonda CODA_09 cattura solo le righe d'ordine; per saperlo
  serve il giornale Esperti completo del reale di quel giorno (una riga di sola lettura sul VPS, cartella
  `C:\BCM_Reale`, da scrivere e passare dal cancello).
- **Il trailing muove lo stop sopra l'ingresso in pochi secondi** su tutti e due: 24/09 FTMO chiude 43 s dopo il fill
  con lo stop a +7,6 punti dall'ingresso; il reale 12 minuti dopo a +3,7. E' la "raffica di modify" gia' segnalata
  nella scheda audit della 770101 (§D): stessa gestione, esito diverso perche' il fill e' avvenuto in momenti diversi.

## 3. Slippage misurato dagli estratti (punti indice; positivo = contro di noi)

| conto | ordine | ingresso: limite -> fill | stop: livello -> chiusura |
|---|---|---|---|
| FTMO | DAX 24/09 buy limit | +0,01 | +1,08 (trailing) |
| FTMO | DAX 25/09 buy limit | **+0,38** (un buy limit riempito SOPRA il limite) | +0,65 (stop pieno) |
| FTMO | MaxMin DAX short 24/09 sell stop | -2,25 (a favore) | +1,88 |
| FTMO | EMA200 Dow 22/09 sell limit x2 | +2,92 / -1,12 | **+7,83 / +7,83** (i due stop nello stesso secondo) |
| FTMO | EMA200 Dow 25/09 sell limit | +1,96 | -0,03 |
| reale | DAX 8 ordini limit 08-24/09 | da -0,3 a +0,7, mediana -0,1 | stop pieni/trailing: 0,0 / +0,1 / +0,7 / +1,7 (le chiusure con parziali a mercato non contano) |

Lettura: sui **limit d'ingresso** i due broker sono simili (decimi di punto). Sugli **stop** FTMO ha il caso peggiore
(+7,83 su US30, due volte), coerente con `MC_STRESS_CONGIUNTO_2026-09-28.md`; sul DAX gli stop FTMO slittano 0,65-1,88.
Campione: 6 posizioni FTMO, 7 reale. Nessuna conclusione statistica: sono i primi numeri veri.

## 4. Cosa resta a mano
- Il giornale Esperti del reale per il 25/09 (perche' la DAX non ha piazzato). Costo: una riga di sola lettura.
- Lo spread vero: SpreadLogger su FTMO (`ABTG_SpreadLogger` e' attaccato a US500.cash H1 su `C:\FTMO`: il suo file
  e' la fonte, non gli estratti).
- Se la differenza di quotazione fra i broker (0,4-7,6 punti, non costante) sia il solo motivo dei fill diversi:
  servono le candele M5 dei due feed dello stesso giorno, non solo gli estratti.
