# REFERTO R35 — La finestra del range 15-60' (13/08): NESSUN CAMBIO, e la cella live del DAX vince l'OOS

## Igiene
Griglie piene 10 celle x 2 finestre x 2 indici, tick reali M5, ricette
pinnate per nome e CONFERMATE nei CSV (sessioni 8:00/14:30 server,
retest, buffer 500/1000, offset 200/400, SOLO LONG, trailing M5 soglia
0, rischio 1%). Unica leva libera: InpRangeMinutes 15->60 passo 5.

## DAX (D30EUR) — la validazione piu' pulita che il 35 potesse ricevere
| RM | IS prof | IS PF | OOS prof | OOS PF | OOS DD% | OOS n |
|---|---|---|---|---|---|---|
| 15 | -924 | 0,78 | +730 | 1,13 | 7,1 | 268 |
| 25 | +426 | 1,15 | +756 | 1,14 | 8,6 | 282 |
| **35 (live)** | +381 | 1,13 | **+1.811** | **1,42** | 6,7 | 270 |
| 40 | -220 | 0,93 | +1.670 | 1,40 | 5,2 | 263 |
| 45 | +97 | 1,03 | +390 | 1,09 | 8,0 | 250 |
| 50 | +714 | 1,26 | +733 | 1,19 | 6,3 | 247 |
| 60 | +737 | 1,31 | +47 | 1,01 | 4,9 | 242 |

- **La cella live (35) e' la MIGLIORE delle 10 fuori campione**, col
  vicino 40 subito dietro (+1.670, PF 1,40): altopiano 35-40 confermato.
- **23° RIBALTAMENTO**: la migliore IS (60, +737) e' la PEGGIORE OOS
  (+47). Chi avesse scelto sull'IS avrebbe buttato la cella d'oro.
- Spearman IS->OOS **-0,24** -> criterio 1: NIENTE si tocca (e per
  fortuna niente ANDAVA toccato).
- Ipotesi pre-numeri (gobba 35-45, 60 morto): sostanzialmente
  CONFERMATA — il confine vero e' 40, il 45 gia' degrada.

## DOW (U30USD) — nessuno sfidante passa i tre cancelli
| RM | IS prof | OOS prof | OOS PF | OOS DD% | OOS n |
|---|---|---|---|---|---|
| 15 | -339 | +1.203 | 1,42 | 4,5 | 153 |
| 25 | +185 | +1.098 | 1,48 | 5,2 | 138 |
| 30 | +23 | +879 | 1,36 | 3,6 | 130 |
| **35 (live)** | +261 | +654 | 1,28 | 4,2 | 130 |
| 45 | -200 | +1.188 | 1,68 | 2,5 | 115 |
| 50 | -238 | +1.166 | 1,66 | 3,3 | 120 |
| 60 | -275 | +289 | 1,17 | 3,8 | 109 |

- Tre celle battono il live in OOS (30/45/50) MA **nessuna ha ENTRAMBI
  i vicini migliori del live**: profilo a due gobbe (15-25 e 45-50) con
  buche in mezzo — crinali, non altopiani. Regola FASE M: un picco
  senza vicini non e' un risultato.
- Spearman **-0,13** -> criterio 1: NIENTE si tocca, punto.
- Ipotesi (stessa gobba del DAX): NON confermata — il profilo Dow e'
  diverso. Onesta' dovuta: l'OOS Dow e' positivo in 10/10 celle, il
  meccanismo retest-long regge OVUNQUE nella griglia; e' la SCELTA
  della finestra che sul Dow non ha un centro netto.

## Verdetto e capitoli chiusi
1. **NESSUN CAMBIO LIVE su nessuno dei due indici** (criteri congelati:
   Spearman negativo su entrambi; sfidanti Dow senza altopiano).
2. **Initial Balance (60') ARCHIVIATA su entrambi gli indici**: DAX
   +47 (peggiore), Dow +289 (quart'ultima). Backlog ORB punto 4 CHIUSO.
3. Il 35 del DAX esce da questo round CON I GRADI: era stato scelto
   dall'altopiano 35-45 di FASE A/M, e su uno split diverso e' la
   migliore cella assoluta fuori campione.

_CSV in `risultati_prove/aperture_r35/`. Prove con ipotesi congelate:
`prove/R35a_range_DAX.txt`, `prove/R35b_range_DOW.txt`._
