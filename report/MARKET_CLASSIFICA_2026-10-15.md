# PAGELLA DEL DEMO PICCOLO 50503392: mattina del 15/10/2026 (report delle ~07:30)

Fonte: `data/statements/ReportHistory_50503392_2026-10-15.xlsx` (mandato da Claudio; analisi di appoggio `backtest_pipeline/analisi_pagella_report_history.py`, NON passata dal cancello). **Il file copre le chiusure dal 15/10 00:01 al 07:25** (443 posizioni, aperte dal 12/10 al 15/10 07:23). Netto delle posizioni (commissioni e swap compresi) **+638,93 EUR** su **7,97 lotti** [MISURATO dal file]. Equity e drawdown non sono nel file.
Join posizione -> ordine per numero: 417 su 443 trovate con commento; **26 senza commento** perche' l'ordine d'apertura sta nel buco fra i report del 14/10 delle 16:52 e quello delle 20:00 [INFERITO]: 25 sono XAUUSD sell 0,08-0,11 aperti il 14/10 fra le 16:15 e le 23:55 (**+194,44**, stesso schema dei cesti dell'Arena [INFERITO]) e 1 e' GBPCAD buy 0,14 (**+25,43**, con SL e TP, EA non identificato).

## 1. Pagella dei profitti (descrittiva: NON e' la classifica di qualita')
| EA (commento) | chiuse | netto EUR | note [MISURATO] |
|---|---:|---:|---|
| **Arena Nexus Grid** (FinlabX/CF/DZR, con `CID`) | 337 | **+280,06** | max lotto 0,17; peggiore posizione -78,11; con SL 121, con TP 214. **+194,44 in piu' se le 25 XAUUSD senza commento sono Arena [INFERITO]** |
| `BuyStop` | 4 | +80,80 | lotti 0,02, tutte con SL e TP; EA non identificato |
| `Basket_#_3_Grid` / `_Initial` e `Basket_#_7_Initial` | 3 | **-2,27** | +63,05 / -71,58 (0,01, **senza SL**) / +6,26: lo stesso cesto 3 netto -8,53 |
| Sample Comment | 5 | +45,68 | peggiore -20,26, senza SL ne' TP |
| SNIPING EA | 35 | +25,22 | 34 vinte su 35, **peggiore -80,58**; con SL 1 su 35, con TP 32; lotti fino a 0,09 |
| **nostra: BULGE VIOLA** (`BULGE_V520_VIOLA_S`) | 1 | +20,08 | EURNZD sell **0,14**, SL 2,00444 TP 1,99459 |
| GZ (Buy + Sell) | 12 | +20,41 | SL su tutte, lotto 0,01, peggiore -3,89 |
| marcalbrechttrading.com | 14 | +9,85 | tutte con TP, senza SL |
| **nostra: EMA200 OTT** | 2 | **-12,59** | AUDCHF buy limit L1 (0,03, -6,24) e L2 (0,05, -6,35): entrambe a SL 0,57813 |
| HedgingMartingale EA | 4 | **-48,18** | 4 perdite su 4, lotto 0,01, con SL |

## 2. Il trade "con il lotto piu' grande del solito"
- **Il candidato piu' probabile: XAUUSD SELL 0,17 dell'Arena** (`FinlabX SELL [CID=842478] [R]`), due volte: **01:23:46** (+92,80) e **02:03:34** (+137,86). Non e' un lotto "fuori scala": e' **l'ultimo gradino della scala di recupero** del cesto 842478. La scala di quel cesto e' 0,01 - 0,01 - 0,02 - 0,02 - 0,03 - 0,03 - 0,04 - 0,04 - 0,05 - 0,05 - 0,08 - 0,08 - 0,11 - 0,11 - **0,17**, poi ricomincia da 0,03. **Il lotto massimo riempito dall'Arena e' 0,17 anche il 13/10 e il 14/10** (0,03 il 12/10) [MISURATO sugli ordini dei quattro file]: oggi non e' piu' grande di ieri, e' lo stesso tetto.
- **Il cesto 842478 in numeri:** 29 posizioni SELL dalle 00:45 alle 02:17, **1,75 lotti d'ingresso in totale**, il gold e' salito da ~4106 a ~4150. **Lotti vivi insieme fino a 0,97**, e il **flottante stimato fino a circa -790 EUR alle 02:03:34** (limite inferiore [DERIVATO], k = 89,36 EUR per 1 USD x 1 lotto): **circa il 13,6% del saldo di 5.827,76 della mezzanotte** prima che il prezzo rientrasse. Chiuso a pezzi (01:25, 02:11, 02:28) con **+41,35 netti** il cesto intero. [Una prop con limite giornaliero del 5% sull'equity l'avrebbe sforato.]
- **Altri due lotti da 0,14 (nostri o attribuibili):** EURNZD sell 0,14 `BULGE_V520_VIOLA_S` (SL a 69 pip: rischio al SL ~48 EUR ~0,8% del saldo [DERIVATO]) e GBPCAD buy 0,14 (SL a 50 pip ~43 EUR [DERIVATO]): lotti dimensionati sul rischio, coerenti con 0,80%.
- Se Claudio intendeva un altro trade (simbolo/ora), si cerca nel file con quella chiave.

## 3. Cosa NON si puo' dire
Un mattino = n piccolo; il flottante e' una stima (limite inferiore); le 26 senza commento sono attribuite per schema, non per commento; la tabella dei profitti non e' una classifica di qualita'. I nostri EA di questa notte (BULGE VIOLA, EMA200 OTT) hanno 3 posizioni in tutto: nessun merito.
