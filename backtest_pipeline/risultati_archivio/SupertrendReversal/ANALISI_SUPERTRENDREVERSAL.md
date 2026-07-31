# SupertrendReversal — Scan OHLC H1 vs H4

_Analisi del 2026-07-31. Fonte: scan OHLC 48 simboli H4 + 45 simboli H1._
_Criterio: miglior pass per simbolo per **Profit Factor**, filtro **≥40 trade** e **profitto > 0**._
_Dati grezzi in `H1_OHLC/` e `H4_OHLC/`. (Validazioni tick reali storiche in `../supertrend_indici_validazione/` e `../SupRev_nuovi_indici/`.)_

---

## 🏆 SupertrendReversal H1 (OHLC)

| # | Simbolo | PF | DD% | Trade | Recovery | dir |
|---|---|---|---|---|---|---|
| 1 | NASUSD | 2.71 | 0.9 | 65 | 4.18 | LONG |
| 2 | EURJPY | 2.63 | 4.5 | 102 | 2.68 | LONG |
| 3 | U30USD (Dow) | 2.62 | 3.2 | 69 | 2.75 | SHORT |
| 4 | D30EUR (DAX) | 2.25 | 2.7 | 101 | 2.77 | LONG |
| 5 | GBPJPY | 2.12 | 2.2 | 95 | 3.50 | LONG |
| 6 | 100GBP (FTSE) | 2.12 | 1.0 | 46 | 2.86 | SHORT |
| 7 | CADJPY | 2.03 | 2.5 | 60 | 2.01 | SHORT |
| 8 | XAUUSD (Oro) | 2.00 | 1.2 | 45 | 1.78 | SHORT |
| 9 | F40EUR (CAC) | 1.99 | 3.6 | 79 | 2.21 | LONG |
| 10 | USDJPY | 1.78 | 2.3 | 64 | 1.69 | LONG |

Validi: 38/45.

## 🏆 SupertrendReversal H4 (OHLC) — **il timeframe forte**

| # | Simbolo | PF | DD% | Trade | Recovery | dir | Note |
|---|---|---|---|---|---|---|---|
| 1 | F40EUR (CAC) | **7.37** | 1.7 | 48 | 5.35 | LONG | ⚠️ PF altissimo, verificare |
| 2 | XAUUSD (Oro) | **4.15** | 1.1 | 43 | 8.89 | LONG | ⭐ recovery 8.89 |
| 3 | AUDUSD | 4.02 | 2.4 | 43 | 3.61 | LONG | |
| 4 | CHFJPY | 3.40 | 2.4 | 84 | 4.53 | LONG | campione ampio |
| 5 | GBPJPY | 3.27 | 2.1 | 73 | 5.37 | L+S | |
| 6 | EURGBP | 3.05 | 1.7 | 40 | 2.56 | LONG | |
| 7 | USDPLN | 2.80 | 1.9 | 45 | 2.99 | LONG | |
| 8 | USOIL | 2.80 | 2.1 | 49 | 2.00 | L+S | |
| 9 | 200AUD | 2.74 | 1.4 | 59 | 2.67 | LONG | |
| 10 | U30USD (Dow) | 2.74 | 4.4 | 73 | 2.07 | LONG | |
| 11 | UKOIL | 2.71 | 2.8 | 62 | 2.30 | LONG | |
| 12 | GBPCHF | 2.49 | 2.4 | 51 | 2.43 | LONG | |

Validi: 38/48.

## 📊 Confronto H1 vs H4 — verdetto

| Simbolo | H1 PF | H4 PF | Migliore |
|---|---|---|---|
| F40EUR (CAC) | 1.99 | **7.37** | **H4** |
| XAUUSD (Oro) | 2.00 | **4.15** | **H4** |
| AUDUSD | — | 4.02 | **H4** |
| CHFJPY | 1.76 | **3.40** | **H4** |
| GBPJPY | 2.12 | **3.27** | **H4** |
| U30USD (Dow) | 2.62 | 2.74 | H4 ≈ |
| D30EUR (DAX) | 2.25 | 2.48 | H4 ≈ |
| **NASUSD** | **2.71** | — | **H1** |
| **EURJPY** | **2.63** | 1.88 | **H1** |

### Conclusioni
1. **Il SupertrendReversal rende molto di più in H4** che in H1, quasi ovunque (CAC 1.99→7.37, Oro 2.00→4.15, CHFJPY 1.76→3.40, GBPJPY 2.12→3.27). H4 è il suo timeframe naturale.
2. **Eccezioni pro-H1**: **NASUSD** (2.71, solo H1, DD 0.9%) ed **EURJPY** (2.63 H1 vs 1.88 H4).
3. **⚠️ F40EUR H4 (PF 7.37)**: PF eccezionalmente alto su 48 trade → possibile overfit, **da confermare a tick reali** prima di fidarsi.
4. **Migliori per la prop (H4, DD basso + PF alto + recovery alto)**: XAUUSD (DD 1.1, rec 8.89), CHFJPY (DD 2.4, 84 trade), GBPJPY, F40EUR (da validare).

## ✅ Prossimi passi
- [ ] **Tick reali H4** sui top: XAUUSD, CHFJPY, GBPJPY, AUDUSD, F40EUR (confermare il 7.37).
- [ ] **Tick reali H1** su NASUSD ed EURJPY (i due che preferiscono H1).
- [ ] Confrontare col portafoglio esistente (SupRev H4 già validati: Multi Oro, DOW_H4, CAC_H4, DAX_H4).
