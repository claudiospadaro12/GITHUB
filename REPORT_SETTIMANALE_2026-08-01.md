# 📊 REPORT SETTIMANALE — 27/07 → 01/08/2026

_Fonte: `weekly_report.pdf` (generato 01/08 09:00) + classifiche consolidate. Analisi Claude._

---

## ⚠️ 0. AVVISO SUI DATI (leggere prima di tutto)
- **Statement INCOMPLETO:** arriva solo al **2026/07/24**, la settimana va al 31/07 → **mancano i trade**.
- **Nessun trade nel periodo** dello statement → sezione "Andamento trade" **vuota**.
- **Forward valido solo dal 01/08** (ricompilazione VPS di ieri): tutto ciò che è prima si scarta comunque.
- 👉 **Conseguenza:** la pagella per-EA a forward **non è possibile questa settimana**. La classifica "EA/simboli migliori" resta quella da **backtest validato tick reali** (sotto), non da forward.

### 🔧 Come avere il report REALE la prossima volta
1. Su MT5: **Cronologia conti** → tasto destro → **Report** → **salva/esporta storico COMPLETO** (tutto il periodo, non solo fino al 24).
2. Ripubblica il CSV/statement (`pubblica_trades.ps1` sul VPS o carica il file qui).
3. Rilancia il report settimanale → allora avremo P/L per EA e magic.

---

## 1. 🎯 Il BIAS del report giornaliero era corretto?
_(Questo è l'UNICO dato reale della settimana: quanto la direzione suggerita dal report giornaliero ha azzeccato.)_

**Affidabilità globale: 20/80 coerenti = 25%** ← sotto il 50% del caso.

| Fascia | Strumenti |
|---|---|
| 🟢 **Buono (≥60%)** | **Nasdaq 80%** (4/5), **Nikkei 60%** (3/5) |
| 🟡 Medio (40-50%) | Rame 50%, Oro 40%, DXY 40%, S&P 33% |
| 🔴 **Scarso (≤25%)** | Argento/Platino/GBPUSD/USDCHF/EURJPY 20%, DAX 25% |
| ⛔ **Zero (0%)** | **FTSE MIB, Petrolio WTI, EUR/USD, USD/JPY, USD/CAD, AUD/USD** |

### 🔑 Lettura
- **Il bias direzionale ha funzionato MALE (25%)**, in particolare **sui forex majors** (EURUSD, USDJPY, USDCAD, AUDUSD tutti **0%**) e su FTSE MIB / WTI.
- Un bias così basso (25%, cioè il mercato ha fatto per lo più il **contrario**) indica una **settimana di reversal/mean-reversion**, non di trend pulito.
- **Implicazione operativa:** una settimana anti-trend **favorisce i motori reversal** (SupertrendReversal, EMA200-rimbalzo) e **penalizza i trend-following/breakout** (aperture!). È coerente col fatto che le **aperture a breakout** stanno soffrendo → altro punto a favore del test **RETEST** in corso.
- **Nasdaq (80%)** resta lo strumento dove la direzione è più leggibile → coerente col fatto che **Nasdaq H1 SupRev** è un nostro candidato prop top.

---

## 2. 🏆 SIMBOLI ed EA MIGLIORI (da backtest validato tick reali — aggiornato)

### Squadra forward attiva: **13 EA, 3 strategie**
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

### ⭐ TOP prop-grade (DD più basso + robusti)
1. **Nikkei 225 SupRev H4** — DD **0.14%** (pochi trade)
2. **Oro SupRev H4** — PF 1.46 / DD 1.2%
3. **Nasdaq SupRev H1** — PF 1.40 / DD 1.2% (a H4 era 0.68 → il TF sblocca il simbolo)
4. **200AUD EMA200 H4** — PF 1.59 / DD 1.4%
5. **GoldenCross USDCHF H4** — PF ~2.6 / DD 1.9%

### 🥇 Miglior STRATEGIA della settimana: **EMA200**
6/8 simboli reggono i tick reali, **nessuno crolla** → il motore più robusto. Appena entrato in forward (5 nuovi il 01/08).

---

## 3. ❌ Confermati SCARTATI
- **Dow / ASX** (SupRev): illusione OHLC, crollano <1 a tick reali.
- **CAC** (SupRev): OHLC 7.37 → reale 0.96 (overfit).
- **Nasdaq apertura M5 breakout**: PF 0.82 (slippage sugli stop) → **in test la variante RETEST**.

---

## 4. ✅ AZIONI DELLA SETTIMANA (fatte)
- **5 EMA200 attaccati in forward** (200AUD/AUDJPY/GBPJPY/SPXUSD/GBPUSD H4) → squadra 8 → 13 EA.
- **Motore apertura M5: implementato RETEST** (limit sul ritorno, leva Emiliano) su US + DAX, opt-in.
- **Script confronto** `confronto_aperture.ps1`: un comando lancia i 4 backtest STOP vs RETEST.

## 5. ⏭️ PROSSIMI PASSI
1. **Esportare statement COMPLETO** da MT5 → report reale con P/L per EA (priorità: senza questo il forward è cieco).
2. **Lanciare `confronto_aperture.ps1`** (tick reali) → verdetto STOP vs RETEST su Dow/Nasdaq/DAX.
3. Lasciar girare il forward: pagella reale tra ~2-3 mesi → walk-forward IS/OOS → dry-run prop 100k.
