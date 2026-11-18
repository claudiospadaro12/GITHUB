# Inventario EA/set sul PC di backtest (18/11/2026) e cosa e gia testato
Fonte: `ELENCO_EA_WIM_20261118_0722.txt` (431 .ex5 in 250 nomi, 2.129 .set, 435 archivi). Sola lettura, nessun test nuovo.

## Famiglie Wim ("WSC", stesso motore, set per mercato)
| Famiglia | Mercati nei .set | Stato nei nostri test |
|---|---|---|
| Ultimate Breakout V9.5 / Goldbot One / Gold Reaper / Gold Phantom / Gold Trade Pro | XAUUSD | oro: cancello 09/11 chiuso (Goldbot One e GTP: TESTATO BENE/CON LIMITI; ottimizzazione UBS in corso) |
| **Stability Pro** | forex | **TESTATO BENE (low risk)**, fuori campione 12 anni, correlazione con oro ~0 |
| **Daytrade Pro** (13 coppie forex + oro) | AUDJPY, AUDUSD, CHFJPY, EURAUD, EURJPY, EURNZD, EURUSD, GBPJPY, GBPUSD, NZDUSD, USDCAD, USDJPY, XAUUSD | Max9/Max20 CON LIMITI (12/12 anni positivi, sensibili ai tick), corr. con oro 0,09-0,19 |
| **Luna AI** | forex multi (scalper notturno) | CON LIMITI (zona grigia sui costi FTMO, -83% a tick) |
| **Apex Trader** (**griglia**) | forex | CON LIMITI (DD 27-33%, giorni a -23%); Conservative e Ultra correlati 0,97 |
| **Bitcoin Reaper / Bitcoin Scalp Pro** | BTCUSD (40 set) | **NON TESTATI** |
| **Indicement** | US30, US500, USTEC (32 set) | **NON TESTATO** (storico BCM indici solo 2024-26: servono dati esterni + cancello D) |
| **ORB Master** | DE40, US30, US500, USTEC (24 set, M15) | **NON TESTATO** (stesso problema dati) |
Tutto in `CANCELLO_CHIUSURA_2026-11-09.md`, `RISULTATI_FOREX_OOS_2026-11-08.md`, `CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md`.

## Altri EA (Market) gia presenti come .ex5
Range Breakout EA with Range Filters, Artemis NAS100 Orb Edge, Pac Man BTC, SomaBTC/SomaGold/SomaOil, BREAKOUT_EA_JPY(_Multi), Master Nasdaq FTMO, Index Sniper Pro, Index Bender, USTEC Dynamics Pro, US100 Nasdaq EA, Opening Range Breakout MT5, The DAX Morning Scalp, DAX Robot, Nasdaq Hacking Pro, ecc. (**non verificati** se sono Market o prove; non sono nel cancello). Molti sono scatole nere senza set: servirebbero input e simboli.

## Lacune rispetto all'obiettivo (6-7 EA scorrelati)
Mercati diversi dall'oro gia coperti: **forex (4 EA)**. Mancano **Bitcoin** e **indici**. Bitcoin dipende dalla copertura storica BCM di BTCUSD (da misurare: non era nel passo 0).
