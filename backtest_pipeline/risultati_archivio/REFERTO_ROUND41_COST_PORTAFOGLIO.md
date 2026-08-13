# REFERTO R41 — Il cost-to-cost nel portafoglio (13/08): QUARTO "AGGIUNGE E ABBASSA" — due nello stesso giorno

## Igiene
Gemelli 3/3 identici (772351-56). Conteggi coerenti con R40 (64/62/41).
Baseline 24 serie riprodotta (+181.996, 5,95%, MC 5,78/10,02/13,17).

## Le tre serie a 100k (finestra OOS, tutte SOLO LONG)
| Serie | Config | Netto | Trade |
|---|---|---|---|
| COST EURJPY | flip di struttura | +22.836 | 64 |
| COST GBPCAD | R-based 1,5R | +16.132 | 62 |
| COST XAGUSD | cost-to-cost puro | +2.266 | 41 |
**Famiglia: +41.234 su 167 trade.**

## Portafoglio 24 -> 27 serie
| | 24 serie | **27 serie** |
|---|---|---|
| Netto OOS | +181.996 | **+223.230 (+23%)** |
| DD storico | 5,95% | **5,50%** |
| Peggior giorno | -4.564 | -4.564 (invariato) |
| MC p50/p95/p99 | 5,78/10,02/13,17 | **5,74/9,89/12,47** |

**Quarto ingresso della storia che aggiunge profitto e abbassa TUTTE
le code (R31 EMA200, R34 BB, R39 LARRY, R41 COST) — il terzo e il
quarto nello stesso giorno.** A 0,65%: p99 = 8,1%.
Trappola n.1 della tesi (parentela PTE) DISINNESCATA dai numeri:
correlazioni PTE vs COST tutte fra -0,09 e +0,08.

## Avvertenze
1. Il ramo B resta il fratello fragile del capitolo Larry: campo scan
   28/48 rosso, promossi 3 su 48 simboli, EURJPY con IS sottile (+55).
   La selezione su campo rosso alza il rischio di fortuna: il forward
   del vivaio pesa di piu' qui che altrove.
2. CHFJPY = 25° ribaltamento (IS L+S +1.825 -> OOS -1.172).
3. E35EUR di nuovo fuori per mancanza tick (2ª volta: gap e cost).
4. Shortlist su dati full-period: mezzo punto, conferma forward.

## PROPOSTA — ✅ ESEGUITA (13/08 sera, "VAI COL VIVAIO COST")
VIVAIO famiglia COST = 3 grafici H4: EURJPY (flip) · GBPCAD (R-based) ·
XAGUSD (cost puro) — tutti SOLO LONG, sedie 27-29, rischio 1%, spread
300, magic forward VERGINI 772361-363. Vivaio a 23 grafici. ~5-6
trade/mese di famiglia -> verdetto dei 15 in ~3 mesi.

**Deploy eseguito il 13/08 sera** (`deploy_vivaio_cost.ps1`, EA compilato
sul VPS: 65.572 byte, primi grafici H4 del vivaio): legge dello
screenshot 3/3 conformi al primo colpo, Salva Profilo ORO, verifica
meccanica v9 dai .chr → **TUTTO OK: 23/23**. Quarto deploy della
giornata dei record.

_CSV in `risultati_prove/ABTG_CostToCost/r41/`, serie in
`risultati_prove/trades_cost/`._
