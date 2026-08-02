# 📋 PAGELLA PER EA — 24/07 → 31/07/2026

_Fonte: `ReportHistory50503392.xlsx`, sezione **Ordini** (colonna Commento) matchata alle posizioni chiuse. Analisi Claude._
_⚠️ Periodo **PRE-FIX** (gestione per-ticket applicata il 01/08) → le perdite DAX sono gonfiate dal bug parziale/BE, ora corretto. Campione piccolo (2 settimane)._

## 🟢 In profitto
| EA | P/L | Trade | Win% | Note |
|---|---|---|---|---|
| **ORB** | **+328,93 €** | 7 | 71% | quasi tutto su Nasdaq; EA "morto" nel backtest → fortuna |
| **NIGHTLY** | +171,29 € | 3 | 100% | piccolo campione |
| **FOMC PostNews** | +142,82 € | 1 | 100% | 1 trade (news Fed) |
| **Nasdaq Live 5m** | +142,09 € | 1 | 100% | 1 solo trade (31/07) |
| **SuperWave DOW H1** | +88,94 € | 4 | 75% | validato, coerente |
| STREV DAX H1 | +56,23 € | 2 | 100% | validato |
| **Nasdaq Apertura US** | +47,21 € | 2 | 100% | l'apertura "vera": modesta |
| STRev (Oro/Argento) | +10,45 € | 2 | 50% | swing, pochi trade |

## 🔴 In perdita
| EA | P/L | Trade | Win% | Note |
|---|---|---|---|---|
| **DAX Live 5m** | **−427,83 €** | 8 | 38% | ☠️ il peggiore — EA "morto" |
| **Apertura Marco** | **−325,74 €** | 8 | 62% | DAX; colpito dal bug gestione (no parziale/BE) → grosse perdite |
| DAX Live5m v2 | −195,75 € | 8 | 38% | "morto" |
| **DAX Apertura EU** | −110,06 € | 19 | 79% | 79% win ma netto negativo = poche perdite enormi (bug gestione) |
| Londra / Londra ORB | −64 / −64 € | 2 | 0% | "morti" |
| STREV Multi | −58,62 € | 1 | 0% | 1 trade |
| _non attribuito_ | +71,34 € | 16 | 38% | commento vuoto (fill parziali/manuali) |
| **TOTALE** | **−186,81 €** | | | |

## 🔑 LETTURE CHIAVE
1. **Il buco è il complesso DAX intraday:** DAX Live5m (−428) + Apertura Marco (−326) + Live5m v2 (−196) + DAX Apertura (−110) = **≈ −1.060 €**. Senza questi la settimana era ampiamente positiva.
2. **Gli EA "morti" sono RUMORE, non segnale:** stessi "morti" alcuni su (ORB +329, Nasdaq Live5m +142), altri disastro (DAX Live5m −428, v2 −196). Non robusti: vincono/perdono a caso. Il backtest 2,5 anni resta la verità.
3. **La parte DAX è gonfiata dal bug gestione** (parziale/BE non scattati, ora corretto il 01/08): Apertura Marco e DAX Apertura dovrebbero migliorare col fix. Da riverificare col forward pulito.
4. **I validati (SupRev/GoldenCross/EMA200) quasi non compaiono:** girano H4/H1 → pochissimi trade in 2 settimane. Normale: la loro pagella arriva tra mesi, non ora.

## ✅ AZIONI SUGGERITE
- 🔴 **Spegnere i "morti" intraday sul DAX** (DAX Live5m, Live5m v2, Londra ORB) — costano e non hanno edge nel backtest. È il buco vero.
- 🟡 **DAX Apertura + Apertura Marco:** riverificare col forward PULITO (post-fix) prima di giudicare — il bug li ha penalizzati.
- 🟢 Lasciar girare i validati: la loro pagella è a mesi.
- ⏳ Ripetere questa pagella ogni settimana (ora che so leggere i commenti) → pagella per-EA reale, non per simbolo.
