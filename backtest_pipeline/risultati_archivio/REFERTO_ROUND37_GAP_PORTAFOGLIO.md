# REFERTO R37 — Gap-fill nel portafoglio (13/08): LA FAMIGLIA INTERA NO, IL TRIO FOREX SI'

## Igiene
Gemelli del magic-sweep IDENTICI su tutte e 5 le coppie (772211-20).
Conteggi OOS coerenti con R36 (15/12/9/8/20). Baseline 15 serie
riprodotta al centesimo (+133.654, 8,74%, MC 6,17/10,78/13,35).

## Le cinque serie a 100k (finestra OOS)
| Serie | Fill | Netto | Trade | DD singolo |
|---|---|---|---|---|
| GAP AUDUSD | 100 | +4.213 | 12 | 1,0% |
| GAP GBPUSD | 100 | +4.176 | 8 | 1,0% |
| GAP U30USD | 100 | +2.462 | 20 | ~1% |
| GAP EURUSD | 50 | +1.993 | 9 | 1,0% |
| GAP 225JPY | 75 | +812 | 15 | 3,6% |

## Portafoglio: il confronto che decide
| | 15 serie | +GAP x5 | +GAP x4 | **+GAP x3 FOREX** |
|---|---|---|---|---|
| Netto | +133.654 | +147.309 | +146.497 | **+144.035** |
| DD storico | 8,74% | 11,13% 🔴 | 10,00% | **8,74% =** |
| Peggior giorno | -4.142 | -6.699 🔴 | -5.667 | -4.564 |
| MC p50/p95/p99 | 6,17/10,78/13,35 | 6,72/11,36/15,14 🔴 | 6,38/10,73/14,18 | **6,12/10,27/13,44** |

**La famiglia intera BOCCIATA dallo standard di portafoglio** (R31/R34:
profitto su E code giu'): alza tutte le code, p99 15,14 x 0,65% = 9,8%
= a un soffio dal 10% FTMO. Causa STRUTTURALE, non di strategia: i gap
scattano tutti alla riapertura (cumulo del lunedi') e Dow/Nikkei si
sommano a serie esistenti sugli stessi simboli (il Dow avrebbe la
SESTA serie). **Il trio forex AUD+GBP+EUR e' invece da manuale**:
+10.381, DD storico invariato, p50 e p95 in DISCESA, p99 +0,09.

## PROPOSTA (decisione a Claudio): VIVAIO famiglia GAP = 3 forex
GAP AUDUSD (fill 100) · GAP GBPUSD (fill 100) · GAP EURUSD (fill 50) —
sedie 16-17-18, H1, rischio 1%, spread filter ACCESO (300), time-stop
48h, magic forward VERGINI da assegnare al deploy. U30USD e 225JPY:
PANCHINA DI PORTAFOGLIO (promossi R36 validi, esclusi per costruzione
di portafoglio: concentrazione simbolo + cumulo del lunedi';
rigiudicabili se il portafoglio cambia forma).

## Avvertenze
1. Trafila invariata: vivaio (regola 15 trade/famiglia) -> 100k. La
   famiglia gap fa ~29 trade OOS/anno sui 3 forex: verdetto in ~6 mesi.
2. Shortlist nata su dati full-period (avvertenza R36): mezzo punto,
   conferma forward.
3. Il gap del lunedi' e' UN evento: anche i 3 forex scattano insieme.
   Correlazioni same-day basse nei dati (i gap dei 3 cambi spesso
   hanno segni/dimensioni diverse), ma il rischio di cluster resta
   dichiarato.

_CSV in `risultati_prove/ABTG_GapFill/r37/` e serie in
`risultati_prove/trades_gap/`._
