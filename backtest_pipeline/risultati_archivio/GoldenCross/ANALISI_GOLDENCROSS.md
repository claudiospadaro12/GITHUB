# GoldenCross — Scan OHLC H1 vs H4 + validazione TICK REALI

_Analisi del 2026-07-31. Fonte: scan OHLC 48 simboli (H1 e H4) + validazione tick reali su 8 simboli (H4)._
_Criterio di selezione: miglior pass per simbolo per **Profit Factor**, con filtro anti-spazzatura **≥40 trade (OHLC) / ≥20 trade (tick reali)** e **profitto > 0**._
_Dati grezzi in `H1_OHLC/`, `H4_OHLC/`, `realtick_H4/`._

---

## 🏆 Classifica H1 (OHLC) — la più forte

| # | Simbolo | PF | DD% | Trade | Recovery | dir | Note |
|---|---|---|---|---|---|---|---|
| 1 | 225JPY | 2.98 | 0.1 | 50 | 6.95 | LONG | ⚠️ sospetto overfit (DD 0.1, ADX lasco) |
| 2 | EURCAD | 2.23 | 4.0 | 43 | 1.81 | LONG | |
| 3 | **XAUUSD (Oro)** | **2.01** | 2.9 | 54 | 2.87 | LONG | ⭐ solido |
| 4 | **USDJPY** | **1.97** | 3.9 | 62 | 2.44 | LONG | ⭐ solido |
| 5 | EURJPY | 1.81 | 4.7 | 44 | 1.04 | LONG | |
| 6 | **GBPUSD** | **1.78** | 2.6 | 59 | 2.72 | LONG | ⭐ solido |
| 7 | NZDCHF | 1.76 | 2.8 | 51 | 1.63 | LONG | |
| 8 | CADCHF | 1.59 | 2.3 | 54 | 1.72 | SHORT | |
| 9 | UKOIL | 1.57 | 2.6 | 43 | 1.20 | LONG | |
| 10 | GBPJPY | 1.55 | 4.3 | 104 | 1.92 | LONG | campione più ampio |

Validi: 27/48. (coda 11–27 sotto PF 1.5, fino a 200AUD 1.00)

## 🏆 Classifica H4 (OHLC) — molto più debole

| # | Simbolo | PF | DD% | Trade | dir |
|---|---|---|---|---|---|
| 1 | **USDCHF** | **2.20** | 2.4 | 40 | L+S |
| 2 | NZDUSD | 1.35 | 3.5 | 48 | L+S |
| 3 | EURAUD | 1.27 | 4.2 | 46 | L+S |
| 4 | CHFJPY | 1.24 | 3.7 | 55 | L+S |
| 5 | EURJPY | 1.17 | 2.7 | 43 | L+S |
| 6 | USDJPY | 1.14 | 5.6 | 41 | L+S |
| 7 | EURUSD | 1.10 | 3.6 | 43 | L+S |
| 8 | NZDCHF | 1.03 | 5.3 | 49 | L+S |

Validi: 10/48. Solo **USDCHF** ha un vero edge su OHLC H4; il resto è marginale.

## 🎯 Validazione TICK REALI (H4) — la prova del nove

| Simbolo | PF | DD% | Trade | Recovery | dir | Coerenza |
|---|---|---|---|---|---|---|
| EURAUD | 3.34 | 1.6 | 21 | 2.56 | SHORT | ⚠️ pochi trade |
| **USDCHF** | **2.63** | 1.9 | 22 | 2.22 | SHORT | ✅ regge OHLC→RT |
| XAGUSD | 2.58 | 4.0 | 27 | 2.57 | L+S | ✅ buono |
| EURUSD | 1.89 | 2.1 | 27 | 1.28 | SHORT | ✅ |
| NZDUSD | 1.70 | 2.8 | 25 | 1.03 | SHORT | ✅ |
| USDCAD | 1.63 | 3.0 | 29 | 0.94 | L+S | |
| CHFJPY | 1.20 | 2.5 | 29 | 0.38 | LONG | debole |

⚠️ Attenzione: i tick reali hanno **pochi trade (21–29)** → PF fragili, da confermare su più storico.

---

## 📊 Confronto H1 vs H4 — verdetto per timeframe

| Simbolo | H1 PF | H4 PF | RT(H4) | Migliore |
|---|---|---|---|---|
| XAUUSD | 2.01 | — | — | **H1** |
| USDJPY | 1.97 | 1.14 | — | **H1** |
| EURJPY | 1.81 | 1.17 | — | **H1** |
| GBPUSD | 1.78 | — | — | **H1** |
| NZDCHF | 1.76 | 1.03 | — | **H1** |
| NZDUSD | 1.36 | 1.35 | 1.70 | H1≈H4 |
| EURUSD | 1.23 | 1.10 | 1.89 | H1 (ma RT buono) |
| **USDCHF** | 1.05 | **2.20** | **2.63** | **H4** ✅ |
| XAGUSD | 1.28 | — | 2.58 | H4 (RT) |
| EURAUD | — | 1.27 | 3.34 | H4 (RT) |

### Conclusioni
1. **Il GoldenCross rende di più in H1**, in generale: top H1 (XAUUSD/USDJPY/GBPUSD ~1.8–2.0, con 54–62 trade) battono nettamente l'H4 (che collassa: solo USDCHF sopra 1.3).
2. **Eccezione netta = USDCHF**: debole in H1 (1.05), forte in H4 sia OHLC (2.20) sia **tick reali (2.63)**. È **la scoperta più robusta** perché sopravvive OHLC→tick reali. **dir SHORT** nei tick reali.
3. **XAGUSD (argento) ed EURAUD**: ottimi nei tick reali H4 (2.58 / 3.34) ma su **pochi trade** → promettenti, da confermare.
4. **225JPY (H1, PF 2.98)**: NON validato — profilo da overfit (DD 0.1, ADX 15). Da testare a tick reali prima di crederci.

## ✅ Prossimi passi
- [ ] **Tick reali H1** sui top H1 non ancora validati: **XAUUSD, USDJPY, GBPUSD** (i più solidi come campione).
- [ ] Confermare **USDCHF H4 SHORT** e **XAGUSD/EURAUD H4** su storico più lungo (pochi trade attuali).
- [ ] Se confermati → creare `ABTG_GoldenCross_USDCHF_H4_Ottimizzato` (e valutare XAGUSD/EURAUD) e inserirli in `CLASSIFICA_PF.md`.
