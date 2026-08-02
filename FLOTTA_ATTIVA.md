# 🖥️ FLOTTA ATTIVA SUL VPS — mappa dai 52 screenshot (02/08/2026)

_Fonte: `EXPERT_CARICATI_SU_VPS.zip` (52 grafici). Nome EA letto in alto a destra di ogni grafico._
_Legenda stato: ✅ validato tick reali · 🟡 nativo/da verificare · ❌ scartato (backtest) · ☠️ "morto" (tenuto per osservazione) · ⚙️ utility._

## 🔎 SCOPERTE IMPORTANTI
- **`NZDCADH1` = `ABTG_TradeExporter`** ⚙️ → è l'exporter che scrive `ABTG_Trades.csv` (con **magic + commento**) in Common\Files. **Ce l'hai già attivo!** Quel CSV dà l'attribuzione per-EA perfetta: caricamelo e faccio pagelle precise al 100%.
- **`D30EURM54` = nessun nome EA visibile** ⚠️ → grafico vuoto o EA staccato. **Da verificare** (se doveva esserci un EA, non sta girando).
- **Concentrazione ORO altissima:** 12 grafici su XAUUSD (3 SupRev + 2 SupRev_Multi + 2 EMA200 + 2 GoldenCross + SupertrendInvert + PTE + WOL). Tanta roba correlata sullo stesso strumento.
- **Concentrazione DAX:** 14 grafici su D30EUR (molti intraday "morti" + aperture).

## 🟢 SQUADRA VALIDATA (i 13 del forward + Ottimizzati)
| Grafico | EA | Simbolo | TF | Stato |
|---|---|---|---|---|
| XAUUSDH4 | SupertrendReversal_Multi_Ottimizzato | Oro | H4 | ✅ TOP (PF bt 3.17) |
| XAUUSDH41 | SupertrendReversal_Ottimizzato | Oro | H4 | ✅ (770901) |
| XAUUSDH42 | EMA200_Ottimizzato | Oro | H4 | ✅ (771501) |
| XAUUSDH1 | GoldenCross_Ottimizzato | Oro | H1 | ✅ (970301) |
| XAGUSDH4 | SupertrendReversal | Argento | H4 | ✅ (770922) |
| 225JPYH4 | SupertrendReversal | Nikkei | H4 | ✅ (770924, DD 0.14%) |
| D30EURH43 | SupertrendReversal | DAX | H4 | ✅ (770923) |
| NASUSDH1 | SupRev_NAS_H1_Ottimizzato | Nasdaq | H1 | ✅ TOP (770925, DD 1.2%) |
| USDCHFH4 | GoldenCross | USDCHF | H4 | ✅ (770331) |
| USDCADH4 | GoldenCross | USDCAD | H4 | ✅ (770332) |
| NZDUSDH4 | GoldenCross | NZDUSD | H4 | ✅ (770333) |
| 200AUDH4 | EMA200 | 200AUD (ASX) | H4 | ✅ (771511) |
| AUDJPYH4 | EMA200 | AUDJPY | H4 | ✅ (771512) |
| GBPJPYH4 | EMA200 | GBPJPY | H4 | ✅ (771513) |
| SPXUSDH4 | EMA200 | S&P (SPXUSD) | H4 | ✅ (771514) |
| GBPUSDH4 | EMA200 | GBPUSD | H4 | ✅ (771515, SHORT) |

## 🟡 IN OSSERVAZIONE / DA VERIFICARE (Ottimizzati + nativi)
| Grafico | EA | Simbolo | TF | Nota |
|---|---|---|---|---|
| D30EURH1 | SupRev_DAX_H1_Ottimizzato | DAX | H1 | 🟡 (970911) |
| D30EURH4 | SupRev_DAX_H4_Ottimizzato | DAX | H4 | 🟡 marginale RT (970912) |
| D30EURH41 | SuperWave_DAX_H4_Ottimizzato | DAX | H4 | 🟡 (770512) |
| D30EURH42 | SuperWave | DAX | H4 | 🟡 nativo |
| D30EURM15 | MaxMinNotte_DAX_Short_Ottimizzato | DAX | M15 | ✅ (770411) |
| D30EURM3 | SuperWave_EA | DAX | M3 | 🟡 test M3 |
| U30USDH12 | SuperWave_DOW_H1_Ottimizzato | Dow | H1 | 🟡 (770511) |
| EURUSDM15 | MaxMinNotte | EURUSD | M15 | 🟡 edge EURUSD |
| EURUSDM152 | Nightly | EURUSD | M15 | 🟡 edge EURUSD |
| EURUSDM5 | HARSI | EURUSD | M5 | 🟡 scan da fare |
| EURJPYM54 | PostNews | EURJPY | M5 | 🟡 |
| EURUSDM54 | PostNews | EURUSD | M5 | 🟡 |
| NASUSDH14 | SupertrendReversal | Nasdaq | H1 | 🟡 nativo (vs Ott) |
| XAUUSDH12 | GoldenCross | Oro | H1 | 🟡 nativo |
| XAUUSDH14 | SupertrendInvert | Oro | H1 | 🟡 da verificare |
| XAUUSDH43 | SupertrendReversal | Oro | H4 | 🟡 nativo |
| XAUUSDH45 | SupertrendReversal_Multi | Oro | H4 | 🟡 nativo |
| XAUUSDH46 | EMA200 | Oro | H4 | 🟡 nativo |
| XAUUSDH47 | PTE | Oro | H4 | 🟡 da verificare |
| XAUUSDDaily | WOL | Oro | D1 | 🟡 da verificare |

## 🎯 APERTURE (il focus di oggi)
| Grafico | EA | Simbolo | TF | Nota |
|---|---|---|---|---|
| D30EURM5 | DAX_Apertura_EU_Ottimizzato | DAX | M5 | apertura validata (770111) — fix gestione + RETEST pronti |
| D30EURM56 | DAX_Apertura_EU | DAX | M5 | apertura nativo |
| D30EURM53 | Apertura_Marco | DAX | M5 | apertura (−326 pre-fix) |
| NASUSDM5 | Nasdaq_Apertura_US_Ottimizzato | Nasdaq | M5 | apertura |
| NASUSDM52 | Nasdaq_Apertura_US | Nasdaq | M5 | apertura nativo |

## ☠️ "MORTI" tenuti per osservazione (decisione Claudio: teniamo tutto fino alla quadra del mese)
| Grafico | EA | Simbolo | TF |
|---|---|---|---|
| D30EURM51 | DAX_Live5m | DAX | M5 |
| D30EURM55 | DAX_Live5m_v2 | DAX | M5 |
| NASUSDM53 | Nasdaq_Live5m | Nasdaq | M5 |
| NASUSDM54 | ORB | Nasdaq | M5 |
| NASUSDM55 | ORB_Fibo | Nasdaq | M5 |

## ❌ SCARTATI (backtest) ma tenuti in osservazione
| Grafico | EA | Simbolo | TF | Perché scartato |
|---|---|---|---|---|
| F40EURH4 | SupRev_CAC_H4_Ottimizzato | CAC | H4 | overfit (RT 0.96) |
| U30USDH4 | SupRev_DOW_H4_Ottimizzato | Dow | H4 | illusione OHLC (RT 0.79) |
| U30USDH1 | SupRev_DOW_H1_Ottimizzato | Dow | H1 | DD 10% |

## ⚙️ UTILITY / DA VERIFICARE
| Grafico | EA | Nota |
|---|---|---|
| NZDCADH1 | **TradeExporter** | scrive ABTG_Trades.csv (magic+commento) → caricalo per pagelle perfette |
| D30EURM54 | **(nessun EA visibile)** | ⚠️ grafico vuoto / EA staccato — verificare |

---
**Totale:** 52 grafici → ~50 EA di trading attivi + 1 exporter + 1 grafico da verificare.
