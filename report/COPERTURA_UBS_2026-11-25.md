# Copertura dati per i set UBS non oro (misurata 25/11/2026, sola lettura sul PC di backtest)

Fonte: `COPERTURA_UBS_20261125_2106.zip` (`report/UBS_COPERTURA/SINTESI_per_simbolo_2026-11-25.csv`): dimensione in MB dei file annuali M1 e mesi di tick nelle cartelle dati di tutti i terminali. **Limite:** legge lo storico scaricato sul PC, non quello che il server potrebbe ancora fornire.

## BCM (terminale principale e portatile `C:\MT5_BCM_Opt`), `BCMMarkets-Server`
| Gruppo (set UBS distinti) | Storico M1 | Densita' (MB/anno mediano) | Tick reali |
|---|---|---|---|
| **EURUSD** (36), **USDJPY** (35) e altri forex (GBPUSD, AUDUSD, USDCAD, USDCHF, NZDUSD, EURJPY, GBPJPY, EURGBP, EURAUD, EURNZD, CHFJPY, AUDJPY) | dal 1993 (EURUSD, USDJPY, USDCHF dal 1971); portatile dal 2009 | **21** (pieno) | 29 mesi da 07/2024 |
| **XAGUSD** (28) | 2016-2026 (11 anni); portatile 2009-2026 | 20 | 28 mesi da 07/2024 |
| **US500** (23) e **USTEC** (32) | nativi SPXUSD/NASUSD solo 2024-2026; **simboli personalizzati `SPXUSD_EXT`, `NASUSD_EXT` 2010-2026 (17 anni)** | 16 / 19,5 | `_EXT`: nessun tick; nativi da 09/2024 |
| **US30** (38) / DE40 (5) | U30USD, D30EUR, F40EUR solo 2024-2026 | 19 / 19 / 10 | da 09/2024 |
| UKOIL/USOIL (XTI: 7) | solo 2024-2026 | 12-19 | da 09/2024 |
| forex `_EXT` (AUDJPY, CHFJPY, EURJPY, EURUSD, GBPUSD, USDJPY) | 2018-2026 | 21,7 | nessuno |

## Altri terminali
- **FTMO** (`Mt5_Ftmo_Prova`, conto Free Trial scaduto): BTCUSD M1 **2011-2026 (16 anni, 21 MB/anno)**, EURUSD 2012-2026 (15 anni), US30.cash 2019-2026 (8 anni, 20 MB/anno); ETHUSD solo 2026; resto 2026. Nel tester il feed FTMO non e' usabile (nota del 25/11).
- **TSLA / Tesla: nessun terminale ha lo storico** (simbolo assente). I 58 set Tesla non si possono provare con i dati attuali.
- FundedNext, Pepperstone, Tickmill: nessun dato utile per questi simboli.

## Lettura per la campagna (set non oro, 741 distinti nell'inventario)
- **Testabili subito su BCM con storico lungo e densita' piena:** EURUSD, USDJPY e gli altri forex (finestre IS 2013-2020, OOS 2021-22, hold-out 2023-24, tick 2025-26 come da `UBS_CAMPAGNA_OTTIMIZZAZIONE_CRITERI`), XAGUSD (IS 2016-2022 sul principale; 2009+ sul portatile).
- **Indici US500/USTEC:** `_EXT` 2010-2026 con densita' piena, ma **orologio verificato solo in 3 blocchi** (CLAUDE.md) e nessun tick: serve la diagnostica dell'orario per ogni blocco prima di fidarsi.
- **Dow/DAX/CAC, petrolio:** solo 2024-26 (hold-out/esplorativo). **Bitcoin:** solo FTMO (feed scaduto: serve simbolo personalizzato da CSV). **Tesla:** nessun dato.
