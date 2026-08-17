# R80 — LA PROVA DI REGIME SU `PTE`: criteri congelati PRIMA dei numeri

**17/08/2026, dopo R79. Quattro celle × cinque finestre, due giri
(dati importati `_EXT` e dati nativi BCM).**

## 1. La domanda, e perche' e' l'ultima tecnica

| round | cosa ha misurato su `PTE USDJPY`, OOS 13 anni |
|---|---|
| **R77** | 0 celle positive su 28 |
| **R78** | 1 su 14 (e quell'una fa +590 in tredici anni, PF 1,011) |
| **R79** | 0 su 8 — e **nessun lato si salva** |

Non e' la **taratura** (R77/R78 hanno spazzato buffer e target) e non e' un
**lato** (R79). Resta l'ipotesi 3 di R78:

> **In quali regimi funziona?**

**Se non esce un "funziona nel regime X" pulito, la domanda smette di essere
tecnica** e diventa: quella sedia deve restare in forward?

## 2. Le celle (parametri copiati, non scelti)

| etichetta | cos'e' |
|---|---|
| `PTEJPY_VIVA` | la sedia **771323**, esattamente com'e' sul VPS |
| `PTEJPY_S25` | la meno peggiore di R79: **solo short / buffer 25** (−515, PF 0,979, DD 7,68%) |
| `PTEGBP_VIVA` | la sedia storica **771322** (termine di paragone del duello) |
| `PTEGBP_B25` | la candidata **771332**, in campo dal 17/08 |

Le due di GBPUSD costano poco e servono a una cosa concreta: **sapere in quali
regimi vince la candidata**, per leggere il forward dei prossimi mesi invece di
guardarlo e basta.

## 3. Le finestre (fissate nel driver, non si toccano)

`ORSO 2022.01-2022.10` · `CROLLO 2020.02-2020.04` · `CROLLO_ANNO 2020` ·
`TORO 2021` · `LATERALE 2019`

## 4. I criteri, che sono gia' quelli di casa

Valgono **`PROVA_REGIME_CRITERI.md`** e l'**emendamento R59**, senza modifiche:

- **A. Sopravvivenza**: nelle finestre avverse (ORSO, CROLLO) conta il RISCHIO.
- **D. Nessuna decisione da UNA sola finestra**: serve la stessa direzione in
  ORSO **e** CROLLO. Un solo periodo avverso e' un aneddoto.
- **Valvola R59**: `n >= 20` verdetto pieno · `8-19` sospeso sul **MERITO** ·
  `< 8` non misurato. **Il campione sottile non sospende MAI il giudizio sul
  RISCHIO**: un drawdown e' un fatto accaduto.
- 🔴 **Clausola di segno** (congelata dopo R77): non si promuove niente che
  perde. "Perde meno" non e' una promozione.

## 5. Cosa decidera' questo round su `771323`, detto adesso

- 🟢 **Se `PTEJPY_VIVA` o `PTEJPY_S25` sono chiaramente POSITIVE in almeno DUE
  finestre su cinque**, con n>=20 -> la sedia ha una ragione di esistere, e si
  scrive **quale** (e quello diventa il suo mandato, non "gira e vediamo").
- 🔴 **Se sono negative quasi ovunque** -> la serie R77-R80 ha risposto, e la
  domanda passa a Claudio: **quella sedia resta o esce?**
- ⏸️ **Se il campione e' troppo sottile** (n<8 in troppe finestre) -> giudizio
  sospeso sul merito e si dichiara. **Ma il rischio si legge lo stesso.**

## 6. I due giri, e perche' due

1. **`_EXT`** (storico importato, dal 2018) — **e' il giro comparabile con
   R56/R59**, che su `PTE_USDJPY` avevano misurato:
   `ORSO −1.888 PF 0,81 n46` · `CROLLO +1.079 PF 2,08 n7` ·
   `LATERALE +203 PF 1,04 n36` · `TORO +3.744 PF 1,90 n40`.
   **Se R80 non riproduce quei numeri, c'e' un problema prima dei verdetti.**
2. **NATIVO** (`-Suffisso ""`) — la sonda del 17/08 ha misurato che il BCM
   nativo su USDJPY parte dal **1971** e su GBPUSD dal **1993**: tutte e cinque
   le finestre ci sono. **E' il dato su cui l'EA opera davvero.**

> 🔬 **Il confronto fra i due giri e' un controllo che non abbiamo mai fatto:
> dice se lo storico importato e quello del broker raccontano la stessa cosa.**
> Se divergono, non e' un dettaglio di questo round — riguarda **tutti** i
> round costruiti sui `_EXT` (R50, R56, R59).

## 7. Limiti dichiarati adesso

- **OHLC** su entrambi i giri (i dati importati sono barre, non tick).
  R57 ha misurato che il solo modello ribalta il segno di questo motore.
  **Questo round PROPONE.**
- Le finestre sono **corte** (3-12 mesi): il campione sara' sottile e la
  valvola R59 mordera'. **E' previsto, non e' una sorpresa da spiegare dopo.**
- 🔴 **Nessuna modifica in forward da questo round**, comprese le due sedie del
  duello, che restano intoccate fino ai 30 trade come congelato ieri.
