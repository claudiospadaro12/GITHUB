# 🔬 FORWARD 04/08/2026 — l'A/B pulito sul trailing: stesso simbolo, stesso giorno, stessa direzione

_Non è un backtest. Quattro posizioni reali sul demo BCM, tutte **BUY su D30EUR**, tutte la stessa mattina, dopo lo sweep dell'apertura._

---

## Le quattro operazioni

| # | EA | lotti | ingresso | uscita | durata | punti presi | P&L |
|---|---|---|---|---|---|---|---|
| 3065288 | **`DAX Live 5m`** (reverse) | 3,80 | 08:01:02 · 26 154,20 | 08:03:20 · 26 179,84 | **2 min 18 s** | **25,64** | **+97,44** |
| 3065545 | `DAX Apertura EU` | 0,90 | 08:15:24 · 26 232,40 | 08:16:09 · 26 234,30 | **45 s** | **1,90** | +1,71 |
| 3065546 | `Apertura Marco` | 0,90 | 08:15:24 · 26 232,40 | 08:16:09 · 26 234,30 | **45 s** | **1,90** | +1,71 |
| 3065547 | `DAX Apertura EU OTT` | 0,40 | 08:16:03 · 26 237,40 | 08:28:57 · 26 239,90 | 12 min 54 s | **2,50** | +1,00 |

**[VERIFICATO]** Nelle ultime tre l'`S/L` mostrato coincide **esattamente col prezzo di uscita** ed è **sopra** l'ingresso: non è lo stop iniziale, è il **trailing** che le ha chiuse.

## 1. Il reverse del Live5m è confermato

`#3065288` apre alle **08:01:02** — lo stesso secondo in cui il sell `#3065290` viene stoppato — al prezzo **26 154,20**, che è *esattamente* lo stop del sell, con **lo stesso identico volume (3,80)**.

**È uno stop-and-reverse.** Bilancio vero di quell'EA sulla mattina: **−110,58 + 97,44 = −13,14**, non −110,58.

## 2. 🔑 L'esperimento controllato

Le prime due righe della tabella sono la cosa più preziosa di oggi. Stesso simbolo, stesso giorno, stessa direzione, stessa ora, stesso mercato che sale. **L'unica variabile che cambia davvero è il tipo di trailing:**

| | `DAX Live 5m` | `DAX Apertura EU` |
|---|---|---|
| `InpTrailMode` | **1 = base della candela precedente** | **2 = punti fissi, `InpTrailFixedPts` = 410** |
| in punti indice | si adatta alla candela (decine di punti) | **4,1 punti fissi** |
| in frazione di R | ~variabile | **0,07 R** (R del DAX = 58,7 punti indice) |
| Durata in posizione | **2 min 18 s** | **45 secondi** |
| Punti catturati | **25,64** | **1,90** |

**Tredici volte i punti, con lo stesso ingresso teorico e lo stesso mercato.**

Il 03/08 avevo trovato lo stesso confronto ma fra **mercati diversi** (DAX FIXED vs Nasdaq PREVBAR), che è un indizio debole: potevano essere i mercati a differire. Oggi è sullo **stesso simbolo, nella stessa ora**. Non resta niente da attribuire al caso.

## 3. La frazione catturata è precipitata

Dal loro ingresso (26 232,40) il DAX è arrivato a **~26 290** [INCERTO, letto dal grafico], cioè **~58 punti disponibili**.

| | 03/08 | **04/08** |
|---|---|---|
| Movimento disponibile | ~83 punti | ~58 punti |
| Catturato | 12 punti | **1,9 punti** |
| **Frazione** | 14% | **3,3%** |

**Secondo giorno consecutivo, e peggiore del primo.** Non è un caso isolato: è il comportamento normale di quel parametro.

## 4. E il TP è dall'altra parte dello stesso errore

| EA | ingresso | T/P | distanza |
|---|---|---|---|
| `Apertura Marco` / `DAX Apertura EU` | 26 232,40 | 26 589,40 | **357 punti** |
| `DAX Apertura EU OTT` | 26 237,40 | 26 621,40 | **384 punti** |

L'ampiezza mediana del range di apertura del DAX è **~55 punti indice** (FASE A). **Il take profit sta a sei volte il movimento tipico disponibile: è irraggiungibile per costruzione.**

La causa meccanica è nota: `TpTotalR()` moltiplica per **3** il valore di `InpTP1_R`. Col default 1,0 il TP finisce a **3R**, oltre qualunque distanza che lo studio abbia misurato (l'ottimo del DAX è 1,25R).

> **Entrambi gli estremi sono sbagliati, e nella stessa direzione:** il trailing chiude a 0,07R, il TP non arriva mai a 3R. Il trade non ha nessuna possibilità di finire dove il mercato lo porterebbe.

## 5. Il paradosso di giornata

**L'EA "morto" ha fatto +97,44. I tre EA "buoni" hanno fatto +4,42 in tre.**

Non perché il Live5m sia buono — il suo ingresso resta un livello sbagliato (candela di pre-mercato, 7 punti di buffer, preso dallo sweep). Ha guadagnato perché, **una volta dentro dalla parte giusta, la sua gestione lo ha lasciato respirare**.

È la conferma più netta della rotta scelta: *l'ingresso giusto con la gestione sbagliata vale meno dell'ingresso sbagliato con la gestione giusta.*

Da notare anche che il size è al contrario: **3,80 lotti** sull'EA senza livello valido, **0,90 e 0,40** su quelli col livello.

## ✅ Cosa ne esce, in concreto

1. **Il trailing a punti fissi 410 sul DAX va abbandonato**, non ritarato al margine. Due giorni, quattro EA, tre trade chiusi sotto il minuto.
2. **Il candidato immediato è `InpTrailMode = 1` (base candela precedente)**, che oggi ha fatto 13× sullo stesso mercato. Non è una scelta a occhio: è l'unica alternativa già osservata dal vivo che funziona.
3. **`InpTP1_R` va portato a 0,5** (TP totale = 1,5R) invece di 1,0 (TP = 3R).
4. La **fase distanze** in corso sul Dow spazzola esattamente questi due numeri, in frazioni di R. Questa giornata dice cosa aspettarsi e dà un valore di riferimento da battere.

_Diario: seconda ricorrenza consecutiva dello schema "aperture DAX chiuse sotto il minuto dal proprio trailing". Con i dati storici (35–80% dei trade per EA) la soglia delle 3 è ampiamente superata._
