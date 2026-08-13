# REFERTO R38 — Le punte di Larry (13/08, "Notte" lampo): 6 PROMOSSI PIENI, l'Oops muore come previsto

## La pipeline autonoma
Prima esecuzione di `notte_larry.ps1`: scan OHLC 48 simboli (24 celle
l'uno) -> selezione AUTOMATICA coi criteri congelati nello script ->
walk-forward tick sui top 8 (pattern+exit pinnati, sweep lati, spread
300). Tutto in ~1 ora di macchina. Igiene confermata nei CSV.

## Le attese dichiarate in tesi: 2 su 2 confermate
1. **OOPS (modo 2): ZERO trade in 288 celle di scan.** Sul CFD
   quasi-24h il gap giornaliero non esiste: pattern strutturalmente
   muto sul nostro broker — esattamente come da fonte 6 (Unger) e
   attese di tesi. Capitolo Oops CHIUSO senza appello (e senza costo).
2. **Asimmetria dei lati** (fonte 7): 4 promossi su 6 sono mono-lato.

## Giudizio walk-forward (criteri congelati: cella lati scelta
## sull'IS; OOS > 0, PF >= 1.10, DD < 10%, n >= 8)
| Simbolo | Pattern/Exit | Lati | IS | OOS | PF | DD | n | Verdetto |
|---|---|---|---|---|---|---|---|---|
| U30USD | Smash punta / R-based | L+S | +152 | **+884** | 1,78 | 3,9% | 38 | ✅ PIENO |
| EURAUD | Smash punta / R-based | L+S | +621 | **+831** | 1,74 | 3,7% | 33 | ✅ PIENO |
| XAUUSD | Smash libro / R-based | SOLO L | +42 | **+783** | **4,23** | 3,5% | 11 | ✅ PIENO (n piccolo) |
| GBPJPY | Smash punta / R-based | SOLO L | +201 | +615 | 2,00 | 2,7% | 20 | ✅ PIENO |
| GBPUSD | Smash libro / FPO | SOLO S | +187 | +440 | 1,84 | 5,1% | 25 | ✅ PIENO |
| EURCAD | Smash punta / FPO | SOLO L | +32 | +132 | 1,25 | 4,8% | 19 | ✅ PIENO (il piu' tirato) |
| GBPAUD | Smash punta / FPO | SOLO L | **-113** | +337 | 1,88 | 4,5% | 15 | ⚠️ RISERVA REGIME (IS rosso) |
| NZDCAD | Smash libro / FPO | SOLO S | +349 | **-329** | 0,68 | 6,3% | 22 | ❌ BOCCIATO — **24° RIBALTAMENTO** |

**Famiglia dei 6 pieni: +3.685 OOS su 146 trade** (deposito 10k, 1%).
Note di colore: GBPJPY e' SOLO LONG con gli altri lati OOS in rosso
profondo (-1.166 lo short): il lato E' l'edge. L'oro promuove il
"libro" con PF 4,23 ma 11 trade: riserva campioni. Il Dow conferma la
sua vocazione long anche qui (L +782 vs S +112 dentro la L+S).

## Vale la nota di sempre
Shortlist scelta su dati full-period (scan) -> mezzo punto; conferma
forward. Con ~1-2 trade/mese a simbolo il verdetto operativo sara' di
FAMIGLIA (regola dei 15).

## Prossimo: R39 per-trade a 100k (magic vergini 772321-332)
6 giri gemelli sui promossi pieni -> dd_portafoglio contro le 18 serie
-> eventuale proposta vivaio famiglia LARRY (decisione a Claudio).
GBPAUD resta in panchina regime con i 4 del gap-fill.

_CSV in `risultati_prove/ABTG_PunteLarry/notte/` (48 scan + 16 wf +
stato). Tesi con attese: `prove/SMASH_DAY_TESI.md`._
