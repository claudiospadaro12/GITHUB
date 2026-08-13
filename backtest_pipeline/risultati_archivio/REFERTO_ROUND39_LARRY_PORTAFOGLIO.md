# REFERTO R39 — Le punte di Larry nel portafoglio (13/08): IL MIGLIOR INGRESSO DELLA STORIA

## Igiene
Gemelli del magic-sweep IDENTICI su tutte e 6 le coppie (772321-332).
Conteggi coerenti con R38 (38/33/11/20/25/19). Baseline 18 serie
riprodotta (+144.035, 8,74%, MC 6,12/10,27/13,44).

## Le sei serie a 100k (finestra OOS)
| Serie | Config | Netto | Trade |
|---|---|---|---|
| LARRY U30USD | Smash punta, R-based, L+S | +11.097 | 38 |
| LARRY EURAUD | Smash punta, R-based, L+S | +8.696 | 33 |
| LARRY GBPJPY | Smash punta, R-based, SOLO L | +6.721 | 20 |
| LARRY XAUUSD | Smash libro, R-based, SOLO L | +5.268 | 11 |
| LARRY GBPUSD | Smash libro, FPO, SOLO S | +4.694 | 25 |
| LARRY EURCAD | Smash punta, FPO, SOLO L | +1.484 | 19 |
**Famiglia: +37.960 su 146 trade.**

## Portafoglio 18 -> 24 serie
| | 18 serie | **24 serie** |
|---|---|---|
| Netto OOS | +144.035 | **+181.996 (+26%)** |
| DD storico | 8,74% | **5,95% — SCESO DI UN TERZO** |
| Peggior giorno | -4.564 | -4.564 (invariato) |
| MC p50/p95/p99 | 6,12/10,27/13,44 | **5,78/10,02/13,17 — tutte giu'** |

**Terza volta nella storia dello standard "aggiunge e abbassa" (dopo
EMA200-R31 e BB-R34), e la piu' netta.** Correlazioni delle 6 nuove:
TUTTE fra -0,17 e +0,04 — anche la sesta serie sul Dow non fa cumulo
(pattern giornaliero vs aperture intraday: mondi diversi). A 0,65% il
p99 = 8,6% < 10% FTMO.

## Avvertenze (di sempre)
Shortlist su dati full-period (mezzo punto, conferma forward); XAUUSD
11 trade OOS = riserva campioni; ~1-2 trade/mese a simbolo -> verdetto
di FAMIGLIA (regola dei 15, famiglia = 6 mercati: ~11 trade/mese
attesi, verdetto vivaio in ~6-8 settimane!).

## PROPOSTA (decisione a Claudio): VIVAIO famiglia LARRY = 6 grafici — ✅ ESEGUITA il 13/08
**"VAI COL VIVAIO LARRY" (13/08 sera).** `deploy_vivaio_larry.ps1` sul
VPS (EA compilato in loco, 71.798 byte, pinnato v1.00) + 6 preset;
legge dello screenshot su tutte e sei le finestre — e ha parato il
**9° errore**: sul GBPUSD era stato caricato il preset del GAP (magic
772231 duplicato!), ricaricato quello giusto prima dell'OK. Verifica
meccanica v8.1: **TUTTO OK 20/20** (falsi errori bool true/false
corretti nel controllore, non nei grafici). Terzo deploy di giornata.
U30USD (punta/R/L+S) · EURAUD (punta/R/L+S) · XAUUSD (libro/R/L) ·
GBPJPY (punta/R/L) · GBPUSD (libro/FPO/S) · EURCAD (punta/FPO/L) —
sedie 21-26, H1, rischio 1%, spread 300 acceso, magic forward VERGINI
772341-346. Il vivaio passerebbe da 14 a 20 grafici. GBPAUD resta in
riserva regime; NZDCAD bocciato (24° ribaltamento).

_CSV in `risultati_prove/ABTG_PunteLarry/r39/` e serie in
`risultati_prove/trades_larry/`._
