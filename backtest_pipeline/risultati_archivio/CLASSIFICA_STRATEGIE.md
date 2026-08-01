# 📊 CLASSIFICA STRATEGIE — indice master (per valutazione PROP)

_Colpo d'occhio unico: per ogni strategia analizzata, il miglior simbolo/TF dagli scan OHLC + stato tick reali._
_Metodo a imbuto: scan OHLC su più TF → migliori → validazione tick reali → candidati prop._
_Ultimo aggiornamento: 2026-07-31._

Legenda TF migliore: dove la strategia rende di più. ✅ = validato tick reali · ⏳ = da validare.

| Strategia | TF migliore | Top simboli (PF OHLC) | Tick reali | Dettaglio |
|---|---|---|---|---|
| **SupertrendReversal** | **H4** (metalli/indici); Nasdaq→H1 | OHLC: CAC 7.37⚠️(overfit), Oro 4.15, CHFJPY 3.40 · **Tick reali (PFmed)**: Nasdaq H1 1.40⭐, Oro 1.46, Argento 1.37, DAX/Nikkei 1.05; **Dow 0.79 e ASX 0.78 CROLLANO** | ✅ 5 in forward (Oro/Argento/DAX/Nikkei H4 + Nasdaq H1); mancano XAU-H4/CHFJPY/GBPJPY/AUDUSD/IBEX-H1 | `SupertrendReversal/ANALISI_*.md` + `TICK_REALI_INDICI_H1vsH4.md` |
| **GoldenCross** | **H1** (ecc. USDCHF→H4) | H1: Oro 2.01, USDJPY 1.97, GBPUSD 1.78 · H4: USDCHF 2.20 | ✅ H4: USDCHF 2.63, XAGUSD 2.58, EURAUD 3.34 | `GoldenCross/ANALISI_GOLDENCROSS.md` |
| **EMA200** | **H4** (H1 da fare) | Tick reali (PFmed): 200AUD 1.59, AUDJPY 1.50 (180tr), GBPJPY 1.46, SPXUSD 1.44, GBPUSD 1.38, Oro 1.33 | ✅ **motore più robusto** (6/8 reggono, nessuno crolla, campioni 100-180tr) | `EMA200/ANALISI_EMA200.md` |

## 🔑 Insight cross-strategia (importante)
- **Ogni motore ha il SUO timeframe naturale**:
  - **SupertrendReversal → H4** (in H1 rende molto meno).
  - **GoldenCross → H1** (in H4 crolla, tranne USDCHF).
- Morale: non esiste un TF unico giusto — va cercato **per strategia**. Per questo lo scan multi-TF è il metodo corretto.

## 🟢 SQUADRA FORWARD (8 EA, validati tick reali — in demo dal 30/07)
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

→ Ora serve **TEMPO**: pagella PF/DD reale forward tra ~2-3 mesi. Poi walk-forward (IS/OOS) → dry-run prop 100k.

## 🚪 Aperture M5 (motore "di contesto" — studio mirato, non scan cieco)
Studiati 8 indici (MAE/MFE/aspettativa in R). Verdetto tick reali: **USA sì, EU no**.
- **Dow apertura M5**: PF 1.16, DD ~8% → edge reale ma **modesto** (priorità bassa; provare variante RETEST con ordini limit).
- **Nasdaq apertura M5**: PF 0.82 → **SCARTATO** (edge OHLC finto, mangiato dallo slippage degli stop).
- EU (FTSE/IBEX/EuroStoxx/CAC/S&P): tutti negativi → **non deployare**.

## 📋 Motori da analizzare (metodo a imbuto H1/H4/…)
✅ Fatti: **SupertrendReversal** · **GoldenCross** · **EMA200** (H4) · MaxMinNotte (EURUSD) · Nightly (EURUSD) · HARSI
🔄 Prossimo: **EMA200 H1** (poi tick reali sui vincitori H4)
❌ Da aggiungere allo scan: **SuperWave** (H1/H4) · **SupertrendInvert** (H1) · **PTE/WOL/FiboH4** (H4/D1)

_Man mano che arrivano gli scan, aggiungere una riga per strategia qui + cartella dedicata in `risultati_archivio/<Strategia>/`._
