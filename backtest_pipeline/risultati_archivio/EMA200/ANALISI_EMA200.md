# EMA200 — Scan OHLC H4

_Analisi del 2026-07-31. Fonte: scan OHLC 47 simboli, TF H4._
_Criterio: miglior pass per simbolo per **Profit Factor**, filtro **≥40 trade** e **profitto > 0**._
_Dati grezzi in `H4_OHLC/`. (Scan H1 ancora da fare.)_

> 💡 Nota di robustezza: a differenza di GoldenCross/SupRev (20-60 trade), l'EMA200 genera **campioni molto ampi (100-300 trade)** su quasi tutti i simboli → PF più affidabili, meno rischio overfit. Motore trend-following (rimbalzo su EMA200) che generalizza bene.

## 🏆 Classifica EMA200 H4 (OHLC, per Profit Factor)

| # | Simbolo | PF | DD% | Trade | Recovery | dir | Note |
|---|---|---|---|---|---|---|---|
| 1 | 200AUD (ASX) | 2.78 | 1.4 | 88 | 2.65 | LONG | ⭐ DD bassissimo |
| 2 | AUDJPY | 2.68 | 3.1 | 180 | 4.68 | LONG | ⭐ 180 trade, rec 4.68 |
| 3 | GBPUSD | 2.61 | 4.3 | 171 | 2.88 | SHORT | 171 trade |
| 4 | U30USD (Dow) | 2.39 | 2.6 | 42 | 3.43 | L+S | pochi trade |
| 5 | USDNOK | 2.30 | 2.8 | 176 | 4.31 | SHORT | |
| 6 | XAUUSD (Oro) | 2.22 | 5.1 | 86 | 2.13 | LONG | il validato storico (era 1.92) |
| 7 | XNGUSD (gas) | 2.14 | 3.0 | 102 | 1.82 | LONG | |
| 8 | GBPJPY | 2.11 | 3.4 | 149 | 3.29 | LONG | |
| 9 | 100GBP (FTSE) | 2.00 | 4.1 | 93 | 1.50 | LONG | |
| 10 | SPXUSD (S&P) | 1.87 | 1.9 | 85 | 2.87 | LONG | ⭐ DD 1.9 |
| 11 | D30EUR (DAX) | 1.81 | 3.8 | 115 | 1.78 | LONG | |
| 12 | CADCHF | 1.78 | 3.0 | 217 | 3.51 | SHORT | 217 trade |
| 13 | CADJPY | 1.75 | 2.7 | 164 | 3.06 | LONG | |
| 14 | 225JPY (Nikkei) | 1.73 | 0.6 | 50 | 1.27 | L+S | ⭐ DD 0.6 |
| 15 | EURJPY | 1.72 | 2.0 | 157 | 2.69 | SHORT | |

_(Validi 41/47. Coda 16-41 da PF 1.60 a 1.01: NZDJPY, F40EUR, EURUSD, EURAUD… fino a USDSEK.)_

## 🎯 Lettura in ottica PROP (DD basso + PF alto + campione ampio)
- **⭐ Top prop**: **200AUD** (PF 2.78, DD 1.4, 88tr), **AUDJPY** (2.68, DD 3.1, **180 trade** = robustissimo), **SPXUSD** (1.87, DD 1.9), **225JPY** (1.73, DD **0.6**).
- **GBPUSD SHORT** (2.61, 171tr) e **USDNOK SHORT** (2.30, 176tr): ottimi PF su campioni ampi.
- **Oro** (2.22) conferma l'edge storico (l'`EMA200_Ottimizzato` era 1.92) ma qui **molti simboli lo battono** → l'EMA200 non è solo da oro.

## ⚠️ Cautela (lezione CAC)
È OHLC: i PF vanno **confermati a tick reali** prima di fidarsi. Vantaggio: i campioni ampi (100-300 trade) rendono l'EMA200 meno esposto all'overfit rispetto a GoldenCross/SupRev.

## 🎯 VALIDAZIONE TICK REALI H4 (fatta 01/08) — 8 simboli
_Metodo robusto: PFmed (mediana dei pass con ≥20 trade, profit>0). Dati in `realtick_H4/`._

| Simbolo | PFmed reale | PFbest | DD%best | Trade | pass pos/tot | PF OHLC | Esito |
|---|---|---|---|---|---|---|---|
| 200AUD (ASX) | **1.59** | 3.03 | 1.4 | 83 | 53/136 | 2.78 | ✅ REGGE ⭐ |
| AUDJPY | **1.50** | 2.31 | 2.5 | 180 | 68/135 | 2.68 | ✅ REGGE ⭐ (180 trade) |
| GBPJPY | **1.46** | 2.06 | 3.4 | 146 | 51/135 | 2.11 | ✅ REGGE |
| SPXUSD (S&P) | **1.44** | 1.78 | 1.9 | 116 | 76/138 | 1.87 | ✅ REGGE ⭐ (55% pass +) |
| GBPUSD | **1.38** | 2.25 | 4.2 | 141 | 64/135 | 2.61 | ✅ REGGE |
| XAUUSD (Oro) | **1.33** | 2.20 | 5.1 | 86 | 89/145 | 2.22 | ✅ REGGE (già in forward) |
| USDNOK | 1.28 | 1.71 | 2.3 | 162 | 32/135 | 2.30 | 🟡 marginale (solo 24% pass +) |
| 225JPY (Nikkei) | 1.27 | 2.55 | **0.2** | 33 | 59/149 | 1.73 | 🟡 marginale (DD bassissimo ma pochi trade) |

### 🔑 Conclusioni
- **EMA200 = il motore PIÙ ROBUSTO finora.** OHLC→tick reali degrada poco e **NESSUN simbolo crolla sotto 1** (contrario di SupRev, dove Dow/ASX/CAC erano illusione OHLC). Merito dei **campioni grandi** (100-180 trade).
- **6 REGGONO** (PFmed ≥ 1.3): 200AUD, AUDJPY, GBPJPY, SPXUSD, GBPUSD, XAUUSD.
- **Candidati prop migliori** (DD basso + robusti): **200AUD** (DD 1.4), **SPXUSD** (DD 1.9, 55% pass positivi = molto stabile), **AUDJPY** (180 trade).
- **Nuove scoperte** (oltre all'Oro già in forward): **200AUD, AUDJPY, GBPJPY, SPXUSD, GBPUSD** → diversificano dal SupRev (metalli/indici) e dal GoldenCross (forex).

## ✅ Prossimi passi
- [ ] Creare **preset forward EMA200** per i 6 validati (200AUD/AUDJPY/GBPJPY/SPXUSD/GBPUSD, oltre a Oro) e metterli in forward → allargare la squadra.
- [ ] (Opz) **Scan EMA200 H1** per confronto TF.
