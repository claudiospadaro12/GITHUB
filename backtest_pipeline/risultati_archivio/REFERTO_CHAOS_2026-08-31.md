# CHAOS LYAPUNOV — screening del gate LLE: TESI FALSIFICATA, candidato NON promosso

_Corsa: 31/08/2026 09:15, pin cc99ea5 (+ override -Fino 2024.01.01 approvato dal
verificatore). ABTG_ChaosLyapunov (EA nuovo, PRIMO compile: OK 57KB), NASUSD_EXT
M15 OHLC Modello 1, 2020.01.01->2024.01.01, sweep 7 soglie x 3 lookback x 5 SL =
105 celle, rischio 1%. Autotest falliti: 0 su 105.
Zip: CHAOS_CORSA_20260831_0915.zip._

## LA LETTURA CONTRO I CRITERI CONGELATI (prima dei numeri, nel prova)

| criterio | esito |
|---|---|
| 1. il gate MORDE (trade monotoni vs soglia) | ✅ PASSA: 15 gruppi su 15 monotoni, 0 piatti — il filtro e' attivo |
| 2. fascia PF>=1.3 E DD<8%, altopiano non outlier | ❌ FALLISCE: **1 cella su 105** (thr+0.06/lb150/sl1.0, PF 1.36, DD 7.8) |
| 3. segmentazione per regime | ⬜ dichiarata NON misurabile in griglia (31/08, prima dei numeri) |

**BOCCIA da regola congelata: "l'edge e' una cella outlier" -> il candidato CADE.**

## LA SCOPERTA VERA (piu' interessante del verdetto): LA TESI E' INVERTITA

La tesi era: "opera SOLO nel regime leggibile (LLE basso), flat nel caos".
La misura dice l'OPPOSTO — PF medio per soglia (15 gruppi):

| soglia | PF medio | celle verdi |
|---|---|---|
| -0.06 (gate strettissimo = solo 'leggibile') | **0.42** | 0/15 |
| -0.03 | 0.39 | 0/15 |
| +0.00 | 0.92 | 1/15 |
| +0.03 | 0.81 | 0/15 |
| +0.06 | 1.07 | 9/15 |
| **+0.09 (gate largo)** | **1.33** | **15/15** |
| +0.12 (il piu' largo del sweep) | 1.25 | 15/15 |

**Piu' si restringe al "regime leggibile", peggio va.** Le celle migliori
(PF 1.4-1.79, banda coerente a thr+0.09 su TUTTI i lookback) stanno al lato
LARGO del gate — dove il filtro si toglie di mezzo. E il n e' sottile ovunque
(55-92 trade in 4 anni a thr+0.09).

**Lettura onesta:** il verde a gate largo e' (quasi certamente) il drift del
Nasdaq 2020-2023 + ottimismo OHLC che attraversano un EMA-cross, NON un edge
del gate. La domanda del round era "il gate LLE trasforma un EMA-cross mediocre
in un edge?" — risposta misurata: **NO: quando il gate lavora, TOGLIE. La
selezione 'LLE basso = predicibile = tradeable' e' falsificata su questi dati.**
(Il DD 8.5-12% a 1% di rischio sopra la barra degli 8% e' il sintomo, non la
causa: non si riscala il rischio DOPO i numeri per far passare un criterio.)

## VERDETTO E DESTINO
- **NON promosso al passo 2** (criteri congelati). Nessun tick, nessun deploy.
- Non si insegue la cella outlier ne' si allarga lo sweep oltre +0.12 verso il
  "gate spento": a quel punto e' un EMA-cross nudo, motore gia' noto mediocre —
  sarebbe la caccia al rumore vietata dalla regola del 19/08.
- Registrato in REGISTRO_TEST.md. Magic 769200 torna libero (mai deployato).
- Lascito utile: il calcolo LLE in MQL5 (AdX-free, phase-space) resta nel
  repo — se mai servira' un indicatore di caos, il mattone c'e' e il suo
  comportamento su indici e' ora MISURATO (selettore inverso, non filtro).
