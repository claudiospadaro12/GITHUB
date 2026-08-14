# REFERTO ROUND 46 — Il dossier MAE/MFE, fase 1: il trailing e' ASSOLTO, il sospettato e' il PARZIALE (14/08/2026)

**Domanda:** dopo tre ricorrenze di "vincente chiuso stretto" (05/08, 12/08
al 6%, 13/08 al 2,3%) e il payoff del 100k (vincita media 82 contro perdita
media 212), il tipo di gestione attuale — parziale 50% a 1R + BE + trailing
PREVBAR M5 — e' il migliore disponibile, o ce n'e' uno che raccoglie di piu'
dello stesso movimento?

## Igiene: SUPERATA

Le due coppie di celle con trailing spento (mode 0 e mode 1, irrilevante)
sono **identiche al centesimo su tutti e quattro i file**. Il round e'
leggibile.

## I numeri OOS (le strutture, ordinate per profitto)

**DAX (D30EUR)** — baseline live = trailing PREVBAR + parziale 50%

| Struttura | Profit OOS | PF | DD % |
|---|---|---|---|
| **PREVBAR, NIENTE parziale** | **+23.607** | **1,49** | **6,27** |
| A = LIVE (PREVBAR + parziale 50%) | +18.030 | 1,40 | 7,23 |
| parziale + BE, poi corre a 3R | +2.281 | 1,03 | 8,74 |
| ATR + parziale | +1.951 | 1,03 | 10,85 |
| ATR senza parziale | −1.834 | 0,97 | 9,82 |
| TP 3R secco (nessuna gestione) | **−14.343** | 0,88 | **22,50** |

**Dow (U30USD)**

| Struttura | Profit OOS | PF | DD % |
|---|---|---|---|
| **PREVBAR, NIENTE parziale** | **+7.343** | 1,26 | 5,43 |
| A = LIVE | +6.722 | **1,27** | **4,39** |
| TP 3R secco | +5.386 | 1,13 | 9,39 |
| ATR senza parziale | +4.834 | 1,14 | 7,83 |
| parziale + BE, poi corre | +1.626 | 1,05 | 6,46 |
| ATR + parziale | +299 | 1,01 | 6,33 |

## Le tre ipotesi scritte prima, alla prova

1. *"Il PREVBAR e' il piu' stretto: raccogliera' meno profitto ma con DD piu'
   basso"* — **FALSIFICATA nella prima meta', confermata nella seconda.** Il
   PREVBAR non raccoglie meno: **e' la migliore delle tre gestioni su
   ENTRAMBI gli indici**, e ha anche il DD piu' basso. Le alternative (ATR,
   nessun trailing) fanno molto peggio fuori campione. **Il trailing e'
   ASSOLTO: non e' il colpevole della vincita media bassa.**
2. *"Il TP 3R e' un ornamento e la struttura senza gestione sara' la
   peggiore"* — **CONFERMATA sul DAX** in modo spettacolare (−14.343, DD
   22,50%: la peggiore di tutte), **NON confermata sul Dow** (+5.386, PF
   1,13 — terza su sei). Il Dow tollera di lasciar correre; il DAX no.
3. *"Non mi aspetto che una struttura vinca su entrambi i cancelli"* —
   **quasi smentita**: togliere il parziale vince su profitto E drawdown sul
   DAX. Ma sul Dow no (vedi sotto).

## IL 27° RIBALTAMENTO

Sul DAX la struttura **TP 3R secco** e' la **migliore in campione** (+48.904,
PF 1,54) e la **peggiore fuori campione** (−14.343, PF 0,88, DD 22,50%).
La stessa struttura, la stessa ricetta d'ingresso: 63.000 euro di differenza
tra le due finestre. Chi avesse scelto sull'IS avrebbe messo in produzione un
motore che perde e che triplica il drawdown.

## VERDETTO SUI CANCELLI (criteri R35, congelati nel file prova)

Candidata: **togliere il parziale, tenere il trailing PREVBAR**.

| Cancello | DAX | Dow |
|---|---|---|
| (a) +10% profitto OOS | ✅ **+30,9%** | ❌ **+9,2%** (sotto soglia per 0,8 punti) |
| (b) DD non peggiore | ✅ 7,23 -> 6,27 | ❌ 4,39 -> **5,43** |
| (c) stessa direzione sui due indici | direzione sì, **cancelli no** | |

**NESSUN CAMBIO ALLA RICETTA LIVE.** Due cancelli su tre falliscono sul Dow, e
il criterio era scritto prima: servono tutti e tre su entrambi gli indici. La
regola non si piega perche' il DAX fa +31%.

## Cosa abbiamo imparato davvero

Il "vincente chiuso stretto" **non e' colpa del trailing**: e' il **parziale
al 50% a 1R** che dimezza la posizione proprio quando il trade comincia a
funzionare. E' il legame diretto con l'osservazione di Claudio sul conto
(vincita media = un terzo della perdita media): meta' posizione esce a 1R,
l'altra meta' la chiude il trailing. Ma **toglierlo costa drawdown sul Dow**,
e il DD e' il vincolo che regge l'intera campagna prop.

## FASE 2 (prossimo passo, gia' pronto)

Per-trade a 100k con magic VERGINI su 4 combinazioni (baseline e candidata,
DAX e Dow): si misurano **win rate e payoff esatti** (vincita media / perdita
media) delle due strutture, il numero che il CSV di ottimizzazione non da'.
Serve a capire il fenomeno e a confrontare tester e live — **non a decidere**:
la decisione l'hanno gia' presa i cancelli, ed e' "si resta come si e'".

_Dati: `risultati_prove/aperture_r46/` (4 CSV). Prove coi criteri congelati:
`prove/R46a_gestione_DAX.txt`, `prove/R46b_gestione_DOW.txt`._
