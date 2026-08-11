# REFERTO R26 — il filtro volumi sul DAX (11/08 notte): NON SI ADOTTA
# La mappa dei volumi sulla famiglia e' completa

## Controlli
- Baseline gemelle 3/3 identiche ✓ e coerenti con l'archivio: la cella
  del titolare riproduce ESATTAMENTE R24 (OOS +1.810,72, PF 1,42, M5
  soglia 0). Doppia conferma incrociata della config del 100k.

## I numeri (vs baseline: IS +381 / OOS +1.811)

| Soglia volumi | IS | OOS | Trade OOS | DD OOS |
|---|---|---|---|---|
| baseline (off) | +381 (PF 1,13) | **+1.811** (PF 1,42) | 270 | 6,71% |
| 1,2 | +355 | +1.649 (PF 1,65) | 150 | 4,39% |
| 1,5 | +550 | +893 (PF 1,54) | 96 | 4,57% |
| 1,8 | +506 | +1.138 (**PF 2,37**) | 62 | **2,59%** |

## Verdetto (criterio 2 congelato: batte la baseline in ENTRAMBE le
## finestre su 2+ soglie)
**In PROFITTO il filtro perde contro la baseline in OOS su 3 soglie su
3** (0/3, non 2/3): NON si adotta. Il titolare del 100k resta com'e' —
terza certificazione della sua cella in 24 ore (walk-forward R24,
baseline R26, e il forward che intanto incassa).

## La sfumatura onesta (annotata, non agita)
Il filtro NON aggiunge profitto ma MIGLIORA la qualita' ovunque:
PF su in tutte e 6 le celle, DD dimezzato o meglio (2,59% a soglia 1,8),
peggior giornata piu' piccola. E' lo stesso carattere visto sul Nasdaq:
i volumi tagliano i trade mediocri. Sul DAX il taglio costa piu' di
quel che rende (il DAX ha gia' un edge senza), sul Nasdaq salvava un
motore senza edge. SE un giorno servisse una variante "prop-grade" a
DD minimo del DAX (rischio piu' alto su meno trade), la cella 1,8 e'
il punto di partenza dichiarato — MA solo con tesi scritta prima e
trafila completa. Non e' un progetto aperto: e' un appunto.

## La mappa VOLUMI della famiglia Apertura, ora completa
| Mercato | Effetto del filtro | Fonte |
|---|---|---|
| Nasdaq | **UNICO edge** (OOS da -764 a +476) | ablazione 03/08 + R24/R25 |
| Dow | danno (non trasferisce) | 03/08 |
| DAX | profitto giu', qualita' su -> non adottato | R26 |
"Non esiste il filtro giusto: esiste quello giusto per QUEL mercato" —
regola del 03/08, ora dimostrata su tutti e tre i mercati.
