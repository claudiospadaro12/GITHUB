# 📊 CLASSIFICA STRATEGIE — indice master (per valutazione PROP)

_Colpo d'occhio unico: per ogni strategia analizzata, il miglior simbolo/TF dagli scan OHLC + stato tick reali._
_Metodo a imbuto: scan OHLC su più TF → migliori → validazione tick reali → candidati prop._
_Ultimo aggiornamento: 2026-07-31._

Legenda TF migliore: dove la strategia rende di più. ✅ = validato tick reali · ⏳ = da validare.

| Strategia | TF migliore | Top simboli (PF OHLC) | Tick reali | Dettaglio |
|---|---|---|---|---|
| **SupertrendReversal** | **H4** (indici); Nasdaq→H1 | OHLC: CAC 7.37⚠️, Oro 4.15, CHFJPY 3.40 · **Tick reali indici**: Nasdaq H1 (100% combo, DD 1.17)⭐, Dow H4 2.77, DAX H4 1.96 | ✅ indici validati (`TICK_REALI_INDICI_H1vsH4.md`); mancano XAU/CHFJPY/GBPJPY/AUDUSD | `SupertrendReversal/ANALISI_SUPERTRENDREVERSAL.md` + `TICK_REALI_INDICI_H1vsH4.md` |
| **GoldenCross** | **H1** (ecc. USDCHF→H4) | H1: Oro 2.01, USDJPY 1.97, GBPUSD 1.78 · H4: USDCHF 2.20 | ✅ H4: USDCHF 2.63, XAGUSD 2.58, EURAUD 3.34 | `GoldenCross/ANALISI_GOLDENCROSS.md` |

## 🔑 Insight cross-strategia (importante)
- **Ogni motore ha il SUO timeframe naturale**:
  - **SupertrendReversal → H4** (in H1 rende molto meno).
  - **GoldenCross → H1** (in H4 crolla, tranne USDCHF).
- Morale: non esiste un TF unico giusto — va cercato **per strategia**. Per questo lo scan multi-TF è il metodo corretto.

## 🎯 Candidati PROP finora (DD basso + PF/recovery alti)
| EA | Simbolo | TF | PF | DD% | Fonte | Stato |
|---|---|---|---|---|---|---|
| SupertrendReversal | XAUUSD | H4 | 4.15 | 1.1 | scan OHLC | ⏳ conferma RT |
| SupertrendReversal | CHFJPY | H4 | 3.40 | 2.4 | scan OHLC | ⏳ conferma RT |
| GoldenCross | USDCHF | H4 SHORT | 2.63 | 1.9 | **tick reali** | ✅ robusto |
| SupertrendReversal | NASUSD | H1 | 2.71 | 0.9 | scan OHLC | ⏳ conferma RT |

## 📋 Prossime strategie da analizzare (stesso metodo H1/H4/…)
- [ ] EMA200 · GoldenCross ✅ · SupertrendReversal ✅
- [ ] SuperWave · MaxMinNotte · Nightly · SupertrendInvert · PTE · WOL · FiboH4_Multi
- [ ] Famiglia aperture (già coperta a parte)

_Man mano che arrivano gli scan, aggiungere una riga per strategia qui + cartella dedicata in `risultati_archivio/<Strategia>/`._
