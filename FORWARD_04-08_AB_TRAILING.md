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

---

# 🇺🇸 Stessa mattina, Nasdaq: la seconda prova, ancora più netta

| # | EA | dir | lotti | ingresso | uscita | durata | P&L |
|---|---|---|---|---|---|---|---|
| 3072139 | `Nasdaq Live 5m` | **SELL** | 2,20 | 14:30:05 · 29 095,80 | 14:30:25 · 29 144,50 = **S/L** | **20 secondi** | **−93,03** |
| 3072134 | **`ORB`** | **BUY** | 1,20 | 14:30:26 · 29 147,50 | 14:33:30 · 29 236,90 = **T/P** | 3 min 4 s | **+93,16** |

**Netto: +0,13 €.** Due EA, stesso simbolo, stesso minuto, direzioni opposte, si sono annullati al centesimo.

## 1. Il Live5m ha venduto sopra tutti i livelli chiave

Dal grafico (indicatore "Livelli Chiave"): **massimo notturno 28 962,7**, **massimo del giorno precedente 28 846,7**.

Ha venduto a **29 095,80**, cioè **133 punti sopra il massimo notturno** e **249 sopra il massimo del giorno prima**. Il Nasdaq aveva già rotto al rialzo *tutto* quello che c'era da rompere, e ha chiuso a **+1,80%**.

Stoppato in **20 secondi**. Terza ricorrenza in due giorni dello stesso difetto — e la più evidente delle tre, perché stavolta non c'era ambiguità sulla direzione.

## 2. 🔑 I due EA stanno sui lati opposti della STESSA candela

| | `Nasdaq Live 5m` | `ABTG_ORB` |
|---|---|---|
| Range | candela **14:25–14:30** (5 min pre-apertura) | candela **14:25–14:30** (5 min pre-apertura) |
| Ordine | **SELL STOP** sotto il minimo (buffer 7 pt) | **BUY STOP** sopra il massimo (10 unità K) |

**Usano la stessa identica finestra e si mettono ai due lati.** Lo sweep dell'apertura è passato prima sotto (ha attivato il sell alle 14:30:05), poi è esploso sopra (stop del sell alle 14:30:25, ingresso dell'ORB alle 14:30:26).

Non è diversificazione: è una **perdita garantita per costruzione**. Qualunque cosa faccia il mercato, uno dei due viene preso dallo sweep.

## 3. La prova diretta sul take profit

Calcolando gli R dai prezzi reali:

| EA | rischio | reward | **TP in R** | esito |
|---|---|---|---|---|
| `Nasdaq Live 5m` | 48,70 | 146,10 | **3,00 R** | mai avvicinato |
| **`ORB`** | 44,70 | 89,40 | **2,00 R** | ✅ **colpito in 3 minuti** |

**[VERIFICATO]** Il TP a 3,00R conferma esattamente `TpTotalR() = 3 × InpTP1_R` col default 1,0. L'ORB invece ha un TP a **2R** — ed è arrivato.

Non è una differenza di fortuna: è che un obiettivo a 2R sta dentro il movimento tipico e uno a 3R no.

## 4. La frazione catturata: 40%

L'ORB ha preso **89,4 punti** su ~224 disponibili fino al massimo di giornata (~29 371,5): **40%**.

| | frazione catturata | come è uscito |
|---|---|---|
| `DAX Apertura EU` (04/08) | **3,3%** | trailing fisso a 0,07R |
| `DAX Apertura EU` (03/08) | 14% | trailing fisso a 0,07R |
| Nasdaq Apertura US (03/08) | 20% | trailing base candela |
| **`ORB` (04/08)** | **40%** | **TP a 2R** |

## 5. L'ORB è l'unico EA della flotta con un'uscita coerente

Stop a 1R, obiettivo a 2R, nessun trailing che tagli prima. E i numeri storici lo confermano: **14 trade, +404 € netti, 0% chiusi sotto il minuto, durata mediana 5 minuti** — il miglior netto della flotta.

Il 03/08 lo avevo criticato perché il suo primo intervento scatta a 2R e "non poteva scattare niente". Era vero quel giorno. Ma **è la stessa proprietà che oggi gli ha fatto raggiungere l'obiettivo**: non taglia sul rumore. Va riletto come un pregio con un costo, non come un difetto.

## 📌 Conseguenze

1. **`InpTP1_R = 0.5`** (TP totale 1,5R) o comunque ≤ 2R: oggi c'è la prova diretta sullo stesso mercato nello stesso minuto.
2. **`Nasdaq Live 5m` e `ABTG_ORB` non vanno tenuti insieme sullo stesso simbolo**: condividono la finestra e si mettono ai lati opposti. È una decisione di flotta da prendere subito, non un parametro da tarare.
3. L'**ORB sale nella considerazione**: è l'unico con una struttura d'uscita sensata, ed è il primo della flotta per netto.
