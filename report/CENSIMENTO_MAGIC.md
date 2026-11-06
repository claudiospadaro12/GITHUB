# CENSIMENTO MAGIC -- la tabella `magic -> EA -> nostro/mercato`

_Generato da `backtest_pipeline/censimento_magic.py` (**sola lettura**: legge il CSV del
TradeExporter e **tutti** i log `CODA_08` del runner; non apre MT5, non va in rete).
Prerequisito della **classe 1530**: senza questa tabella sono esposti il netto della
flotta, il censimento delle compresenze e il **criterio di uscita del 18/08**, che
decide **per famiglia** chi si spegne._

## 🔴 PERIMETRO, e va letto prima dei numeri

Questa tabella copre **un solo conto: il piccolo `50503392`** (`trades_auto.csv`).
**NON** include `trades_100k.csv` (100k `50504263`), dove **cinque** nostri magic hanno
altre **43** operazioni. 🔴 **E non e' accademico: `770611` arriva cosi' a n=20, che e'
esattamente la soglia MERITO del criterio del 18/08** — e i due conti hanno **segno
opposto** (piccolo −212,16 · 100k +549,75).

📏 **`n` e' additivo fra i conti e decide la soglia; il NETTO no**: il lotto medio di
`770611` e' **0,591 sul piccolo** contro **7,356 sul 100k** (**12,4x**), quindi sommare i
netti sarebbe la classe **1526** (basi mescolate) nella forma piu' rumorosa.

## Riepilogo (piccolo `50503392`)

| classe | magic | operazioni | netto |
|---|---|---|---|
| **NOSTRO** | 67 | 1088 | **-1233.41** |
| **DA CONFERMARE** | 3 | 11 | **+140.41** |
| **MERCATO** | 26 | 6991 | **-3809.34** |
| **MANUALE** | 1 | 677 | **-19667.88** |
| _somma_ | 97 | 8767 | -24570.22 |

## 🔴 L'ETICHETTA DELLA PAGELLA E' SBAGLIATA, e questa tabella lo dimostra

`analizza_trades.py` definisce la flotta come `magic == 0 -> fuori` e stampa **«Totale
della sola flotta»**. Misurato con la partizione dichiarata qui sopra: `magic != 0` sono
**8090 operazioni / -4902.34**, di cui **6991 / -3809.34 sono MERCATO** = **86% delle righe**.

👉 **«Sola flotta» e' da mesi l'etichetta di un numero che non e' la flotta.** In certe
giornate non cambia nulla (il 30/10, il 03, 04 e 05/11 tutte le righe sono nostre), ma il
**14/10** erano **1.206 righe di mercato contro 13 nostre**.

## La regola, dichiarata prima dei numeri — SEI casi, nell'ordine del codice

0. **MANUALE** se `magic == 0`: non e' un EA, MT5 ci mette le operazioni **a mano**.
   🔴 Era il **primo** caso del codice e mancava da tutte e due le liste pubblicate
   (classe **1532**), pur spostando **-19667.88**.
1. **NOSTRO** se il preset `.chr` associa al magic un EA `ABTG_*` o `CLAU12_*`.
2. **MERCATO** se il preset associa un EA con un altro nome. 🔴 Controesempio reale:
   `250604` sta in un nostro `.chr`, ma l'EA e' `Gold_Ichimoku_TK_ATR_EA`:
   **stare in un nostro grafico non rende nostro un EA.**
3. **MERCATO** se il commento porta un marchio di mercato noto.
4. **NOSTRO** se il commento porta un marchio delle nostre famiglie.
5. **DA CONFERMARE** in ogni altro caso. 🔴 **Non si indovina: si stampa.**

🔴 **`magic != 0` NON vuol dire "nostro"**, e nessun criterio numerico separa i due
insiemi: i magic di mercato hanno valori qualunque (`888`, `1234567`, `5318008`,
`20260810`, `778899`...). 📌 Le due liste di marchi sono scritte **a mano** dai commenti
del CSV e dai preset `EA_Comment=` — **non** dai sorgenti `.mq5`, che non contengono
queste stringhe — e sono **disgiunte** (l'autotest lo asserisce).

## NOSTRO (67 magic, 1088 operazioni, netto -1233.41)

| magic | n | netto | anche sul 100k | prova | commenti |
|---|---|---|---|---|---|
| `20250001` | 297 | -1158.06 | — | commento di casa: BULGE_ | BULGE_MULTI_SIGNAL_BLU_L / BULGE_MULTI_SIGNAL_BLU_S / BULGE_MULT |
| `772700` | 220 | -317.70 | — | preset .chr: ABTG_Bulge | BULGE_V520_VIOLA_L / BULGE_V520_VIOLA_S / BULGE_V520_BLU_L |
| `774500` | 91 | -88.71 | — | preset .chr: ABTG_BulgeAzzurra | BULGE_AZZURRA_AZZURRA_L / BULGE_AZZURRA_AZZURRA_S |
| `770101` | 48 | -461.97 | **n=17, +1659.20** | preset .chr: ABTG_DAX_Apertura_EU / CLAU12_DAX_Apertura_EU | DAX Apertura EU RETEST BUY / DAX Apertura EU BUY / DAX Apertura  |
| `971501` | 30 | -4.85 | — | preset .chr: ABTG_EMA200_Ottimizzato | EMA200 OTT S1 / EMA200 OTT S2 / EMA200 OTT L1 |
| `771531` | 23 | -54.71 | — | preset .chr: ABTG_EMA200 / CLAU12_EMA200 | EMA200 DOW L1 / EMA200 DOW S1 / EMA200 DOW L2 |
| `770511` | 21 | +443.92 | — | preset .chr: ABTG_SuperWave_DOW_H1_Ottimizzato / CLAU12_SuperWave_DOW_H1_Ottimizzato | SUPERWAVE DOW H1 S 1/3 / SUPERWAVE DOW H1 S 2/3 / SUPERWAVE DOW  |
| `770601` | 20 | +351.51 | — | commento di casa: ORB  | ORB BUY / ORB SELL |
| `770103` | 19 | +410.63 | — | commento di casa: DAX LIVE | DAX Live 5m BUY / DAX Live 5m SELL |
| `770402` | 18 | +146.89 | — | preset .chr: ABTG_MaxMinNotte | MAXMIN ORO SELL / MAXMIN ORO BUY |
| `772361` | 16 | -288.27 | — | preset .chr: ABTG_CostToCost | COST EURJPY L |
| `770531` | 16 | -91.32 | — | preset .chr: ABTG_SuperWave | SW DOW H2 S 1/3 / SW DOW H2 S 2/3 / SW DOW H2 L 1/3 |
| `772362` | 14 | +90.22 | — | preset .chr: ABTG_CostToCost | COST GBPCAD L |
| `990001` | 13 | -29.22 | — | commento di casa: SUPERWAVE | SUPERWAVE EA 1 / SUPERWAVE EA 2 / SUPERWAVE EA 3 |
| `770121` | 12 | -149.27 | — | commento di casa: DAX LIVE | DAX Live5m v2 BUY / DAX Live5m v2 SELL |
| `970913` | 12 | +15.95 | — | preset .chr: ABTG_SupRev_NAS_H1_Ottimizzato | STREV NAS H1 L 1/3 / STREV NAS H1 S 1/3 |
| `772421` | 12 | -49.56 | — | preset .chr: ABTG_EasyTrend | EASYTREND CHFJPY S / EASYTREND CHFJPY L / EZ CHFJPY S |
| `770611` | 11 | -212.16 | **n=9, +549.75** | preset .chr: ABTG_ORB_Ottimizzato | ORB OTT BUY |
| `772422` | 11 | +218.99 | — | preset .chr: ABTG_EasyTrend | EASYTREND GBPUSD S / EASYTREND GBPUSD L / EZ GBPUSD S |
| `770201` | 10 | +228.34 | — | commento di casa: NASDAQ APERTURA | Nasdaq Apertura US SELL / Nasdaq Apertura US BUY |
| `770501` | 9 | -121.47 | — | commento di casa: DAX M3 | DAX M3 L / DAX M3 S |
| `771501` | 9 | -52.51 | — | commento di casa: EMA200 | EMA200 S1 / EMA200 S2 / EMA200 L1 |
| `770111` | 8 | +30.32 | — | commento di casa: DAX APERTURA | DAX Apertura EU OTT BUY |
| `770311` | 8 | -179.51 | — | commento di casa: APERTURA MARCO | Apertura Marco BUY / Apertura Marco SELL |
| `770202` | 8 | -8.88 | **n=6, +14.06** | preset .chr: ABTG_Dow_Apertura_US / CLAU12_Dow_Apertura_US | Dow Apertura US RETEST BUY / Dow Apertura US BUY |
| `772342` | 8 | +28.72 | — | preset .chr: ABTG_PunteLarry | LARRY EURAUD L / LARRY EURAUD S |
| `770411` | 7 | +142.34 | **n=5, +907.77** | preset .chr: ABTG_MaxMinNotte_DAX_Short_Ottimizzato / CLAU12_MaxMinNotte_DAX_Short_Ottimizzato | MAXMIN DAX SHORT SELL |
| `770250` | 7 | +3.66 | — | preset .chr: ABTG_Nasdaq_Apertura_US | Nasdaq Apertura US SELL |
| `770203` | 6 | +206.63 | — | commento di casa: NASDAQ LIVE | Nasdaq Live 5m BUY / Nasdaq Live 5m SELL |
| `770701` | 6 | -257.94 | — | commento di casa: LONDRA | Londra BUY / LONDRA ORB BUY |
| `771701` | 6 | +295.55 | — | commento di casa: NIGHTLY | NIGHTLY L / NIGHTLY S |
| `774101` | 6 | -139.21 | — | preset .chr: ABTG_GapContinuation | GAPCONT S / GAPCONT L |
| `772341` | 6 | -86.11 | — | preset .chr: ABTG_PunteLarry | LARRY DOW S / LARRY DOW L |
| `770924` | 6 | +0.84 | — | preset .chr: ABTG_SupertrendReversal | STREV FW Nik S 1/3 / STREV FW Nik L 1/3 |
| `970916` | 5 | +42.09 | — | commento di casa: STREV | STREV DOW H1 L 1/3 / STREV DOW H1 L 2/3 |
| `771001` | 4 | -140.45 | — | commento di casa: STREV | STREV MULTI S 1/3 / STREV MULTI S 2/3 |
| `772345` | 4 | +56.09 | — | preset .chr: ABTG_PunteLarry | LARRY GBPUSD S |
| `970901` | 4 | -29.88 | — | preset .chr: ABTG_SupertrendReversal_Ottimizzato | STREV OTT L 1/3 / STREV OTT S 1/3 |
| `770502` | 3 | -43.81 | — | commento di casa: DAX M3 | DAX M3 L |
| `770901` | 3 | -81.46 | **n=6, -132.87** | preset .chr: ABTG_SupertrendReversal | STREV S 1/3 |
| `770211` | 3 | +46.34 | — | commento di casa: NASDAQ APERTURA | Nasdaq Apertura US OTT BUY |
| `771322` | 3 | +33.40 | — | preset .chr: ABTG_PTE | PTE GBPUSD S / PTE GBPUSD L |
| `772343` | 3 | +44.00 | — | preset .chr: ABTG_PunteLarry | LARRY ORO L |
| `772161` | 3 | +43.06 | — | preset .chr: ABTG_BreakingBand | BB GBPUSD INV S / BB GBPUSD INV L |
| `772344` | 3 | -93.55 | — | preset .chr: ABTG_PunteLarry | LARRY GBPJPY L |
| `772233` | 3 | -85.74 | — | preset .chr: ABTG_GapFill | GAP AUDUSD L / GAP AUDUSD S |
| `770401` | 2 | +75.91 | — | commento di casa: MAXMIN | MaxMin BUY |
| `770102` | 2 | -118.74 | — | commento di casa: DAX APERTURA | DAX Apertura EU OTT BUY |
| `970911` | 2 | +56.23 | — | commento di casa: STREV | STREV DAX H1 L 1/3 / STREV DAX H1 L 2/3 |
| `771202` | 2 | +141.68 | — | preset .chr: ABTG_PostNews | FOMC PostNews BUY |
| `970915` | 2 | +67.64 | — | commento di casa: STREV | STREV CAC H4 L 1/3 / STREV CAC H4 L 2/3 |
| `770925` | 2 | -3.69 | — | commento di casa: STREV | STREV L 1/3 |
| `772423` | 2 | -10.40 | — | commento di casa: EZ  | EZ AUDJPY S |
| `772162` | 2 | -43.11 | — | preset .chr: ABTG_BreakingBand | BB EURUSD CONT S |
| `772235` | 2 | +37.82 | — | preset .chr: ABTG_GapFill | GAP NIKKEI S / GAP NIKKEI L |
| `771201` | 2 | -80.42 | — | preset .chr: ABTG_PostNews | ECB PostNews SELL / ECB PostNews BUY |
| `771332` | 2 | +3.19 | — | preset .chr: ABTG_PTE | PTE GBPUSD B25 L / PTE GBPUSD B25 S |
| `772232` | 2 | +24.23 | — | preset .chr: ABTG_GapFill | GAP EURUSD L / GAP EURUSD S |
| `20240001` | 1 | +9.54 | — | commento di casa: BULGE_ | BULGE_V3_CLEAN |
| `771301` | 1 | -35.60 | — | commento di casa: PTE  | PTE S |
| `772346` | 1 | +12.52 | — | preset .chr: ABTG_PunteLarry | LARRY EURCAD L |
| `771323` | 1 | +9.29 | — | commento di casa: PTE  | PTE USDJPY L |
| `772363` | 1 | -35.56 | — | commento di casa: COST  | COST XAGUSD L |
| `772234` | 1 | -50.70 | — | preset .chr: ABTG_GapFill | GAP DOW L |
| `772163` | 1 | +12.45 | — | preset .chr: ABTG_BreakingBand | BB AUDUSD INV L |
| `771321` | 1 | +3.78 | — | preset .chr: ABTG_PTE | PTE DOW S |
| `771203` | 1 | +37.36 | — | preset .chr: ABTG_PostNews | NFP PostNews SELL |

## DA CONFERMARE (3 magic, 11 operazioni, netto +140.41)

| magic | n | netto | anche sul 100k | prova | commenti |
|---|---|---|---|---|---|
| `20252606` | 6 | +150.71 | — | commento VUOTO e magic non nei .chr | _(vuoto)_ |
| `111` | 4 | -87.55 | — | commento VUOTO e magic non nei .chr | _(vuoto)_ |
| `24759` | 1 | +77.25 | — | commento non riconosciuto: 24759 | 24759 |

## MERCATO (26 magic, 6991 operazioni, netto -3809.34)

| magic | n | netto | anche sul 100k | prova | commenti |
|---|---|---|---|---|---|
| `888` | 5559 | -1706.40 | — | preset .chr, EA non nostro: Arena Nexus Grid Smart XAU MT5 | FinlabX BUY [CID=842373] [R] / CF S [F] [CID=842376] / CF S [F]  |
| `20260810` | 432 | -2161.51 | — | preset .chr, EA non nostro: Gold Sniping | SNIPING EA |
| `1` | 291 | +54.71 | — | preset .chr, EA non nostro: Gold Zone EA | GZ Buy TP1 / GZ Buy TP2 / GZ Buy TP3 |
| `5318008` | 275 | -444.77 | — | preset .chr, EA non nostro: MATrader AI MT5 | marcalbrechttrading.comA / marcalbrechttrading.com3917642 / marc |
| `8398` | 115 | +166.74 | — | commento di mercato: DARK VENUS | Dark Venus |
| `937843` | 86 | -213.43 | — | commento di mercato: SAMPLE COMMENT | Sample Comment |
| `85736` | 85 | +543.90 | — | commento di mercato: HEDGINGMARTINGALE | HedgingMartingale EA / SellStop / BuyStop |
| `202504` | 44 | +96.13 | — | commento di mercato: SSP SCALP | SSP scalp |
| `1212312121` | 27 | -19.20 | — | commento di mercato: NANG_KWAK | Nang_Kwak_Gold_Trader_S5 / Nang_Kwak_Gold_Trader_S6 |
| `105091` | 15 | +246.85 | — | preset .chr, EA non nostro: Martingale Pulse | MP by SPLpulse |
| `1234567` | 13 | +90.09 | — | commento di mercato: BASKET_ | Basket_1234567_1_Initial / Basket_1234567_2_Initial / Basket_123 |
| `202503` | 8 | -36.12 | — | preset .chr, EA non nostro: SafeScalperPro | SSPv4 |
| `20292807` | 8 | +29.82 | — | commento di mercato: SUPERSCALP PRO | SuperScalp Pro Sell |
| `778899` | 5 | -706.18 | — | commento di mercato: TIG BREAKOUT | TIG Breakout LOW / TIG Breakout HIGH |
| `1609493055` | 4 | +76.82 | — | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute |
| `1609493057` | 4 | +167.41 | — | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute |
| `20260001` | 3 | -55.32 | — | commento di mercato: NIGHT_BREAK_BOX | NIGHT_BREAK_BOX_BRK_UP |
| `20260728` | 3 | +22.27 | — | preset .chr, EA non nostro: Diagonal Resistance EA | DResEA#1 (53) / DResEA#2 (53) / DResEA-R#1 (53) |
| `1609493059` | 3 | +96.84 | — | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute |
| `8888` | 3 | +0.54 | — | commento di mercato: APEX ORIGIN | Apex Origin |
| `250604` | 2 | -82.39 | — | preset .chr, EA non nostro: Gold_Ichimoku_TK_ATR_EA | IchiCross long / IchiCross short |
| `6266492026051904` | 2 | -0.19 | — | commento di mercato: GUNNER E | Gunner E |
| `123456` | 1 | -0.09 | — | commento di mercato: NQ_V21 | NQ_v21_S |
| `80526001` | 1 | +15.25 | — | commento di mercato: NASDAQMASTEREA | NasdaqMasterEA v1.0 |
| `123456789` | 1 | -0.86 | — | commento di mercato: MAXOPPCATCHER | MaxOppCatcher Buy |
| `28081965` | 1 | +9.75 | — | preset .chr, EA non nostro: Gold Candle Bot | _(vuoto)_ |

## MANUALE (1 magic, 677 operazioni, netto -19667.88)

| magic | n | netto | anche sul 100k | prova | commenti |
|---|---|---|---|---|---|
| `0` | 677 | -19667.88 | **n=1, -2862.41** | magic 0 = operazioni a mano, non un EA | _(vuoto)_ / SUPERWAVE MANUALE SELL 1 / SUPERWAVE SELL |

