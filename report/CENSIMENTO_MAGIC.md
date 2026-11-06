# CENSIMENTO MAGIC -- la tabella `magic -> EA -> nostro/mercato`

_Generato da `backtest_pipeline/censimento_magic.py` (sola lettura: legge il CSV
del TradeExporter e il log `CODA_08` del runner). Prerequisito della **classe 1530**:
senza questa tabella sono esposti il netto della flotta, il censimento delle
compresenze e il **criterio di uscita del 18/08**, che decide **per famiglia**._

## Riepilogo

| classe | magic | operazioni | netto |
|---|---|---|---|
| **NOSTRO** | 67 | 1088 | **-1233.41** |
| **DA CONFERMARE** | 4 | 12 | **+150.16** |
| **MERCATO** | 25 | 6990 | **-3819.09** |
| **MANUALE** | 1 | 677 | **-19667.88** |

## La regola, dichiarata prima dei numeri

1. **NOSTRO** se il preset `.chr` associa al magic un EA `ABTG_*` o `CLAU12_*`.
2. **MERCATO** se il preset associa un EA con un altro nome. 🔴 Controesempio
   reale: `250604` sta in un `.chr`, ma l'EA e' `Gold_Ichimoku_TK_ATR_EA`:
   **stare in un nostro grafico non rende nostro un EA.**
3. **MERCATO** se il commento porta un marchio di mercato noto.
4. **NOSTRO** se il commento porta un marchio delle nostre famiglie.
5. **DA CONFERMARE** in ogni altro caso. 🔴 **Non si indovina: si stampa.**

🔴 **`magic != 0` NON vuol dire "nostro"**, e nessun criterio numerico separa i
due insiemi: i magic di mercato hanno valori qualunque (`888`, `1234567`,
`5318008`, `20260810`, `778899`...).

## NOSTRO (67 magic, 1088 operazioni, netto -1233.41)

| magic | n | netto | prova | commenti | simboli |
|---|---|---|---|---|---|
| `20250001` | 297 | -1158.06 | commento di casa: BULGE_ | BULGE_MULTI_SIGNAL_BLU_L / BULGE_MULTI_SIGNAL_BLU_S / BULGE_MULTI_SIGN | AUDCAD AUDJPY AUDNZD AUDUSD CADCHF ... |
| `772700` | 220 | -317.70 | preset .chr: ABTG_Bulge | BULGE_V520_VIOLA_L / BULGE_V520_VIOLA_S / BULGE_V520_BLU_L | AUDCAD AUDJPY AUDNZD AUDUSD CADCHF ... |
| `774500` | 91 | -88.71 | preset .chr: ABTG_BulgeAzzurra | BULGE_AZZURRA_AZZURRA_L / BULGE_AZZURRA_AZZURRA_S | 200AUD 225JPY AUDJPY AUDNZD AUDUSD ... |
| `770101` | 48 | -461.97 | preset .chr: ABTG_DAX_Apertura_EU | DAX Apertura EU RETEST BUY / DAX Apertura EU BUY / DAX Apertura EU SEL | D30EUR NASUSD |
| `971501` | 30 | -4.85 | preset .chr: ABTG_EMA200_Ottimizzato | EMA200 OTT S1 / EMA200 OTT S2 / EMA200 OTT L1 | AUDCHF XAUUSD |
| `771531` | 23 | -54.71 | commento di casa: EMA200 | EMA200 DOW L1 / EMA200 DOW S1 / EMA200 DOW L2 | U30USD |
| `770511` | 21 | +443.92 | preset .chr: ABTG_SuperWave_DOW_H1_Ottimizzato | SUPERWAVE DOW H1 S 1/3 / SUPERWAVE DOW H1 S 2/3 / SUPERWAVE DOW H1 L 1 | U30USD |
| `770601` | 20 | +351.51 | commento di casa: ORB  | ORB BUY / ORB SELL | NASUSD |
| `770103` | 19 | +410.63 | commento di casa: DAX LIVE | DAX Live 5m BUY / DAX Live 5m SELL | D30EUR NASUSD |
| `770402` | 18 | +146.89 | preset .chr: ABTG_MaxMinNotte | MAXMIN ORO SELL / MAXMIN ORO BUY | XAUUSD |
| `772361` | 16 | -288.27 | preset .chr: ABTG_CostToCost | COST EURJPY L | EURJPY |
| `770531` | 16 | -91.32 | preset .chr: ABTG_SuperWave | SW DOW H2 S 1/3 / SW DOW H2 S 2/3 / SW DOW H2 L 1/3 | U30USD |
| `772362` | 14 | +90.22 | preset .chr: ABTG_CostToCost | COST GBPCAD L | GBPCAD |
| `990001` | 13 | -29.22 | commento di casa: SUPERWAVE | SUPERWAVE EA 1 / SUPERWAVE EA 2 / SUPERWAVE EA 3 | D30EUR |
| `770121` | 12 | -149.27 | commento di casa: DAX LIVE | DAX Live5m v2 BUY / DAX Live5m v2 SELL | D30EUR |
| `970913` | 12 | +15.95 | preset .chr: ABTG_SupRev_NAS_H1_Ottimizzato | STREV NAS H1 L 1/3 / STREV NAS H1 S 1/3 | NASUSD |
| `772421` | 12 | -49.56 | preset .chr: ABTG_EasyTrend | EASYTREND CHFJPY S / EASYTREND CHFJPY L / EZ CHFJPY S | CHFJPY |
| `770611` | 11 | -212.16 | preset .chr: ABTG_ORB_Ottimizzato | ORB OTT BUY | U30USD |
| `772422` | 11 | +218.99 | preset .chr: ABTG_EasyTrend | EASYTREND GBPUSD S / EASYTREND GBPUSD L / EZ GBPUSD S | GBPUSD |
| `770201` | 10 | +228.34 | commento di casa: NASDAQ APERTURA | Nasdaq Apertura US SELL / Nasdaq Apertura US BUY | NASUSD |
| `770501` | 9 | -121.47 | commento di casa: DAX M3 | DAX M3 L / DAX M3 S | D30EUR |
| `771501` | 9 | -52.51 | commento di casa: EMA200 | EMA200 S1 / EMA200 S2 / EMA200 L1 | D30EUR XAUUSD |
| `770111` | 8 | +30.32 | commento di casa: DAX APERTURA | DAX Apertura EU OTT BUY | D30EUR |
| `770311` | 8 | -179.51 | commento di casa: APERTURA MARCO | Apertura Marco BUY / Apertura Marco SELL | D30EUR |
| `770202` | 8 | -8.88 | preset .chr: ABTG_Dow_Apertura_US | Dow Apertura US RETEST BUY / Dow Apertura US BUY | U30USD |
| `772342` | 8 | +28.72 | preset .chr: ABTG_PunteLarry | LARRY EURAUD L / LARRY EURAUD S | EURAUD |
| `770411` | 7 | +142.34 | preset .chr: ABTG_MaxMinNotte_DAX_Short_Ottimizzato | MAXMIN DAX SHORT SELL | D30EUR |
| `770250` | 7 | +3.66 | preset .chr: ABTG_Nasdaq_Apertura_US | Nasdaq Apertura US SELL | NASUSD |
| `770203` | 6 | +206.63 | commento di casa: NASDAQ LIVE | Nasdaq Live 5m BUY / Nasdaq Live 5m SELL | NASUSD |
| `770701` | 6 | -257.94 | commento di casa: LONDRA | Londra BUY / LONDRA ORB BUY | GBPUSD |
| `771701` | 6 | +295.55 | commento di casa: NIGHTLY | NIGHTLY L / NIGHTLY S | EURUSD |
| `774101` | 6 | -139.21 | preset .chr: ABTG_GapContinuation | GAPCONT S / GAPCONT L | 225JPY |
| `772341` | 6 | -86.11 | preset .chr: ABTG_PunteLarry | LARRY DOW S / LARRY DOW L | U30USD |
| `770924` | 6 | +0.84 | preset .chr: ABTG_SupertrendReversal | STREV FW Nik S 1/3 / STREV FW Nik L 1/3 | 225JPY |
| `970916` | 5 | +42.09 | commento di casa: STREV | STREV DOW H1 L 1/3 / STREV DOW H1 L 2/3 | U30USD |
| `771001` | 4 | -140.45 | commento di casa: STREV | STREV MULTI S 1/3 / STREV MULTI S 2/3 | XAUUSD |
| `772345` | 4 | +56.09 | preset .chr: ABTG_PunteLarry | LARRY GBPUSD S | GBPUSD |
| `970901` | 4 | -29.88 | preset .chr: ABTG_SupertrendReversal_Ottimizzato | STREV OTT L 1/3 / STREV OTT S 1/3 | XAUUSD |
| `770502` | 3 | -43.81 | commento di casa: DAX M3 | DAX M3 L | D30EUR |
| `770901` | 3 | -81.46 | commento di casa: STREV | STREV S 1/3 | XAUUSD |
| `770211` | 3 | +46.34 | commento di casa: NASDAQ APERTURA | Nasdaq Apertura US OTT BUY | NASUSD |
| `771322` | 3 | +33.40 | preset .chr: ABTG_PTE | PTE GBPUSD S / PTE GBPUSD L | GBPUSD |
| `772343` | 3 | +44.00 | preset .chr: ABTG_PunteLarry | LARRY ORO L | XAUUSD |
| `772161` | 3 | +43.06 | preset .chr: ABTG_BreakingBand | BB GBPUSD INV S / BB GBPUSD INV L | GBPUSD |
| `772344` | 3 | -93.55 | preset .chr: ABTG_PunteLarry | LARRY GBPJPY L | GBPJPY |
| `772233` | 3 | -85.74 | preset .chr: ABTG_GapFill | GAP AUDUSD L / GAP AUDUSD S | AUDUSD |
| `770401` | 2 | +75.91 | commento di casa: MAXMIN | MaxMin BUY | D30EUR |
| `770102` | 2 | -118.74 | commento di casa: DAX APERTURA | DAX Apertura EU OTT BUY | D30EUR |
| `970911` | 2 | +56.23 | commento di casa: STREV | STREV DAX H1 L 1/3 / STREV DAX H1 L 2/3 | D30EUR |
| `771202` | 2 | +141.68 | preset .chr: ABTG_PostNews | FOMC PostNews BUY | EURUSD |
| `970915` | 2 | +67.64 | commento di casa: STREV | STREV CAC H4 L 1/3 / STREV CAC H4 L 2/3 | F40EUR |
| `770925` | 2 | -3.69 | commento di casa: STREV | STREV L 1/3 | NASUSD |
| `772423` | 2 | -10.40 | commento di casa: EZ  | EZ AUDJPY S | AUDJPY |
| `772162` | 2 | -43.11 | preset .chr: ABTG_BreakingBand | BB EURUSD CONT S | EURUSD |
| `772235` | 2 | +37.82 | preset .chr: ABTG_GapFill | GAP NIKKEI S / GAP NIKKEI L | 225JPY |
| `771201` | 2 | -80.42 | preset .chr: ABTG_PostNews | ECB PostNews SELL / ECB PostNews BUY | EURJPY |
| `771332` | 2 | +3.19 | preset .chr: ABTG_PTE | PTE GBPUSD B25 L / PTE GBPUSD B25 S | GBPUSD |
| `772232` | 2 | +24.23 | preset .chr: ABTG_GapFill | GAP EURUSD L / GAP EURUSD S | EURUSD |
| `20240001` | 1 | +9.54 | commento di casa: BULGE_ | BULGE_V3_CLEAN | NZDJPY |
| `771301` | 1 | -35.60 | commento di casa: PTE  | PTE S | XAUUSD |
| `772346` | 1 | +12.52 | preset .chr: ABTG_PunteLarry | LARRY EURCAD L | EURCAD |
| `771323` | 1 | +9.29 | commento di casa: PTE  | PTE USDJPY L | USDJPY |
| `772363` | 1 | -35.56 | commento di casa: COST  | COST XAGUSD L | XAGUSD |
| `772234` | 1 | -50.70 | preset .chr: ABTG_GapFill | GAP DOW L | U30USD |
| `772163` | 1 | +12.45 | preset .chr: ABTG_BreakingBand | BB AUDUSD INV L | AUDUSD |
| `771321` | 1 | +3.78 | preset .chr: ABTG_PTE | PTE DOW S | U30USD |
| `771203` | 1 | +37.36 | preset .chr: ABTG_PostNews | NFP PostNews SELL | USDJPY |

## DA CONFERMARE (4 magic, 12 operazioni, netto +150.16)

| magic | n | netto | prova | commenti | simboli |
|---|---|---|---|---|---|
| `20252606` | 6 | +150.71 | commento VUOTO e magic non nei .chr | _(vuoto)_ | XAUUSD |
| `111` | 4 | -87.55 | commento VUOTO e magic non nei .chr | _(vuoto)_ | XAUUSD |
| `28081965` | 1 | +9.75 | commento VUOTO e magic non nei .chr | _(vuoto)_ | XAUUSD |
| `24759` | 1 | +77.25 | commento non riconosciuto: 24759 | 24759 | XAUUSD |

## MERCATO (25 magic, 6990 operazioni, netto -3819.09)

| magic | n | netto | prova | commenti | simboli |
|---|---|---|---|---|---|
| `888` | 5559 | -1706.40 | commento di mercato: FINLABX | FinlabX BUY [CID=842373] [R] / CF S [F] [CID=842376] / CF S [F] [CID=8 | XAUUSD |
| `20260810` | 432 | -2161.51 | commento di mercato: SNIPING | SNIPING EA | XAUUSD |
| `1` | 291 | +54.71 | commento di mercato: GZ BUY | GZ Buy TP1 / GZ Buy TP2 / GZ Buy TP3 | XAUUSD |
| `5318008` | 275 | -444.77 | commento di mercato: MARCALBRECHTTRADING | marcalbrechttrading.comA / marcalbrechttrading.com3917642 / marcalbrec | XAUUSD |
| `8398` | 115 | +166.74 | commento di mercato: DARK VENUS | Dark Venus | EURUSD |
| `937843` | 86 | -213.43 | commento di mercato: SAMPLE COMMENT | Sample Comment | XAUUSD |
| `85736` | 85 | +543.90 | commento di mercato: HEDGINGMARTINGALE | HedgingMartingale EA / SellStop / BuyStop | XAUUSD |
| `202504` | 44 | +96.13 | commento di mercato: SSP SCALP | SSP scalp | XAUUSD |
| `1212312121` | 27 | -19.20 | commento di mercato: NANG_KWAK | Nang_Kwak_Gold_Trader_S5 / Nang_Kwak_Gold_Trader_S6 | XAUUSD |
| `105091` | 15 | +246.85 | commento di mercato: MP BY SPLPULSE | MP by SPLpulse | XAUUSD |
| `1234567` | 13 | +90.09 | commento di mercato: BASKET_ | Basket_1234567_1_Initial / Basket_1234567_2_Initial / Basket_1234567_3 | XAUUSD |
| `202503` | 8 | -36.12 | commento di mercato: SSPV | SSPv4 | XAUUSD |
| `20292807` | 8 | +29.82 | commento di mercato: SUPERSCALP PRO | SuperScalp Pro Sell | XAUUSD |
| `778899` | 5 | -706.18 | commento di mercato: TIG BREAKOUT | TIG Breakout LOW / TIG Breakout HIGH | XAUUSD |
| `1609493055` | 4 | +76.82 | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute | XAUUSD |
| `1609493057` | 4 | +167.41 | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute | XAUUSD |
| `20260001` | 3 | -55.32 | commento di mercato: NIGHT_BREAK_BOX | NIGHT_BREAK_BOX_BRK_UP | XAUUSD |
| `20260728` | 3 | +22.27 | commento di mercato: DRESEA | DResEA#1 (53) / DResEA#2 (53) / DResEA-R#1 (53) | XAUUSD |
| `1609493059` | 3 | +96.84 | commento di mercato: XAUUSD 5 MINUTE | XAUUSD 5 Minute | XAUUSD |
| `8888` | 3 | +0.54 | commento di mercato: APEX ORIGIN | Apex Origin | AUDCAD |
| `250604` | 2 | -82.39 | preset .chr, EA non nostro: Gold_Ichimoku_TK_ATR_EA | IchiCross long / IchiCross short | XAUUSD |
| `6266492026051904` | 2 | -0.19 | commento di mercato: GUNNER E | Gunner E | XAUUSD |
| `123456` | 1 | -0.09 | commento di mercato: NQ_V21 | NQ_v21_S | NASUSD |
| `80526001` | 1 | +15.25 | commento di mercato: NASDAQMASTEREA | NasdaqMasterEA v1.0 | NASUSD |
| `123456789` | 1 | -0.86 | commento di mercato: MAXOPPCATCHER | MaxOppCatcher Buy | EURUSD |

## MANUALE (1 magic, 677 operazioni, netto -19667.88)

| magic | n | netto | prova | commenti | simboli |
|---|---|---|---|---|---|
| `0` | 677 | -19667.88 | magic 0 = operazioni a mano, non un EA | _(vuoto)_ / SUPERWAVE MANUALE SELL 1 / SUPERWAVE SELL | 225JPY AUDCAD AUDCHF AUDJPY AUDNZD ... |

