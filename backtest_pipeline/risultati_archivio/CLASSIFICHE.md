# 🏆 CLASSIFICHE CONSOLIDATE — EA · Simboli · Strategie

_Vista unica di tutte le classifiche. Aggiornato: 2026-07-31._
_Fonti: `CLASSIFICA_PF.md` (PF backtest), `CLASSIFICA_STRATEGIE.md` (matrice motori), analisi tick reali per strategia._
_Regola d'oro: conta il **PF a TICK REALI** (non l'OHLC, che sovrastima) e il **DD basso** (per la prop)._

---

## 1️⃣ CLASSIFICA EA (per Profit Factor backtest real-tick) — i 14 `_Ottimizzato`

| # | EA | Simbolo | TF | PF bt | DD% | 🎯 Prop |
|---|---|---|---|---|---|---|
| 1 | SupRev_Multi | Oro | H4 | 3.17 | basso | ⭐⭐⭐ |
| 2 | SupRev_DOW_H4 | Dow | H4 | 2.77 | 4.0 | ❌ crolla a tick reali |
| 3 | SupRev | Oro | H4 | 2.74 | basso | ⭐⭐⭐ |
| 4 | MaxMinNotte_DAX_Short | DAX | M15 | 2.05 | 3.1 | ⭐⭐⭐ |
| 5 | SupRev_DAX_H4 | DAX | H4 | 1.96 | 5.7 | ⭐⭐ |
| 6 | EMA200 | Oro | H4 | 1.92 | basso | ⭐⭐⭐ |
| 7 | SupRev_CAC_H4 | CAC | H4 | 1.79 | 3.5 | ❌ overfit (RT 0.96) |
| 8 | GoldenCross | Oro | H1 | 1.58 | basso | ⭐⭐ |
| 9 | SupRev_NAS_H1 | Nasdaq | H1 | 1.57 | 1.2 | ⭐⭐⭐ |
| 10 | SuperWave_DOW_H1 | Dow | H1 | 1.52 | 4.0 | ⭐⭐ |
| 11 | DAX_Apertura_EU | DAX | M5 | 1.49 | 3.8 | ⭐ |
| 12 | SupRev_DAX_H1 | DAX | H1 | 1.45 | 5.6 | ⭐ |
| 13 | SuperWave_DAX_H4 | DAX | H4 | 1.28 | 3.3 | ⭐ |
| 14 | SupRev_DOW_H1 | Dow | H1 | 1.20 | 10 | ❌ DD troppo alto |

⚠️ Il PF backtest è storico/OHLC. **A tick reali Dow e CAC crollano** → vedi sezione 2.

---

## 2️⃣ CLASSIFICA per SIMBOLO (edge validato a TICK REALI)

### SupertrendReversal (PFmed tick reali)
| Simbolo | TF | PFmed reale | DD% | Trade | Esito |
|---|---|---|---|---|---|
| Oro (XAUUSD) | H4 | 1.46 | 1.2 | 44 | ✅ ⭐ |
| Nasdaq (NASUSD) | H1 | 1.40 | 1.2 | — | ✅ ⭐ (a H4 era 0.68!) |
| Argento (XAGUSD) | H4 | 1.37 | 2.5 | 27 | ✅ |
| DAX (D30EUR) | H4 | 1.05 | 2.1 | 50 | ✅ marginale |
| Nikkei (225JPY) | H4 | 1.05 | 0.14 | 21 | ✅ poco attivo |
| Dow (U30USD) | H4 | 0.79 | 3.3 | 56 | ❌ CROLLA (illusione OHLC) |
| ASX (200AUD) | H4 | 0.78 | 1.6 | 42 | ❌ CROLLA |

### GoldenCross (PF tick reali H4)
| Simbolo | PF reale | DD% | Trade | Esito |
|---|---|---|---|---|
| EURAUD | 3.34 | 1.6 | 21 | ✅ (pochi trade) |
| USDCHF | 2.63 | 1.9 | 22 | ✅ robusto |
| XAGUSD | 2.58 | 4.0 | 27 | ✅ |
| EURUSD | 1.89 | 2.1 | 27 | ✅ |
| NZDUSD | 1.70 | 2.8 | 25 | ✅ |
| USDCAD | 1.63 | 3.0 | 29 | ✅ |

_(GoldenCross OHLC H1 top: Oro 2.01, USDJPY 1.97, GBPUSD 1.78 — tick reali H1 ancora da fare.)_

---

## 3️⃣ CLASSIFICA per STRATEGIA (matrice motore × TF)

| Strategia | TF migliore | Migliori simboli | Stato |
|---|---|---|---|
| **SupertrendReversal** | **H4** (Nasdaq→H1) | Oro, Argento, Nasdaq H1 | ✅ analizzato |
| **GoldenCross** | **H1** (USDCHF→H4) | Oro, USDJPY (H1); USDCHF (H4) | ✅ analizzato |
| **EMA200** | **H4** | Tick reali: 200AUD 1.59, AUDJPY 1.50, GBPJPY 1.46, SPXUSD 1.44, GBPUSD 1.38, Oro 1.33 | ✅ **il più robusto** (6/8 reggono tick reali, nessuno crolla) |
| MaxMinNotte | M15 | EURUSD, DAX short | ✅ (EURUSD) |
| Nightly | M15 | EURUSD | ✅ (EURUSD) |
| HARSI | M5 | — | scan pronto |
| SuperWave / SupertrendInvert / PTE / WOL / FiboH4 | H1/H4/D1 | — | ❌ da aggiungere allo scan |

🔑 **Insight cross-strategia**: ogni motore ha il **suo** timeframe naturale (SupRev→H4, GoldenCross→H1). Il TF sblocca il simbolo (Nasdaq: spazzatura in H4, top in H1). → lo scan multi-TF è obbligatorio.

---

## 🟢 LA CLASSIFICA CHE CONTA: SQUADRA FORWARD (8 EA, validati tick reali)

| EA | Simbolo | TF | PF reale | DD% | Magic |
|---|---|---|---|---|---|
| SupRev | Oro XAUUSD | H4 | 1.46 | 1.2 | 770921 |
| SupRev | Argento XAGUSD | H4 | 1.37 | 2.5 | 770922 |
| SupRev | DAX D30EUR | H4 | 1.05 | 2.1 | 770923 |
| SupRev | Nikkei 225JPY | H4 | 1.05 | 0.14 | 770924 |
| SupRev | Nasdaq NASUSD | H1 | 1.40 | 1.2 | 770925 |
| GoldenCross | USDCHF | H4 | ~2.6 | 1.9 | 770331 |
| GoldenCross | USDCAD | H4 | ~1.6 | 3.0 | 770332 |
| GoldenCross | NZDUSD | H4 | ~1.7 | 2.8 | 770333 |
| EMA200 | 200AUD (ASX) | H4 | 1.59 | 1.4 | 771511 |
| EMA200 | AUDJPY | H4 | 1.50 | 2.5 | 771512 |
| EMA200 | GBPJPY | H4 | 1.46 | 3.4 | 771513 |
| EMA200 | SPXUSD (S&P) | H4 | 1.44 | 1.9 | 771514 |
| EMA200 | GBPUSD (SHORT) | H4 | 1.38 | 4.2 | 771515 |

_(5 EMA200 aggiunti 01/08 → squadra da 8 a **13 EA**, 3 strategie. Oro EMA200 già coperto da EMA200_Ott 771501, non duplicato.)_

→ In demo dal 30/07 (EMA200 dal 01/08). Serve **tempo**: pagella forward reale ~2-3 mesi → walk-forward IS/OOS → dry-run prop 100k.

**⭐ Candidati prop-grade (DD più basso):** Nasdaq H1 (1.2%), Oro H4 (1.2%), Nikkei H4 (0.14%), GoldenCross USDCHF (1.9%).

---

## ❌ Scartati (imparato dai tick reali)
- **Dow / ASX** (SupRev): crollano sotto 1 a tick reali — erano illusione OHLC.
- **CAC** (SupRev): OHLC 7.37 → tick reali 0.96. Overfit clamoroso.
- **H1 indici europei** (SupRev): marginali.
- **Nasdaq apertura M5**: PF 0.82, edge OHLC finto (slippage sugli stop).

## ⏳ Ancora da validare
- SupRev: IBEX (E35EUR) H1, XAU/CHFJPY/GBPJPY/AUDUSD H4, EURJPY H1
- GoldenCross: tick reali H1 sui top OHLC (Oro, USDJPY, GBPUSD)
- EMA200: scan H4 (in corso) + H1
