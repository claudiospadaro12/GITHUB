# FASE I e FASE L — 07/08/2026

Due domande, due risposte. Una **annulla una decisione già presa in forward**, l'altra
chiude il Nasdaq d'apertura.

⚠️ **Prima di tutto: come si è comportato MT5 sugli enum.** Non spazzola *tutti* i valori
dell'enum: spazzola **tutti i membri dell'enum compresi fra `start` e `stop`**, ignorando lo
`step`. Con `InpTrailTF=5||1||4||5||Y` sono usciti **M1, M2, M3, M4, M5** — cinque celle, non
ventidue. È più preciso di quanto avessi scritto, e cambia come si progettano le fasi:
**gli estremi contano, lo step no.**

---

# FASE I — il timeframe del trailing

Configurazione: `BREAKOUT`, range 15, buffer 300, gestione accesa (TP 3R + parziale 50% +
breakeven), rischio 1%, `TRAIL_PREVBAR`. Sweep su `InpTrailTF`.

## ❌ Il controllo dichiarato è FALLITO — e questo è il risultato

Prima di lanciare avevo scritto:

> *«Sul DAX questa fase serve anche da controllo del metodo: **deve ritrovare M5 meglio di
> M1**, altrimenti la misura è sbagliata e non mi fido del resto.»*

**Non l'ha ritrovato.** Ma la ragione non è che la misura è rotta: è che **la misura del
05/08 era in campione.**

### DAX — profitto per timeframe

| | M1 | M2 | M3 | M4 | M5 |
|---|---:|---:|---:|---:|---:|
| **IS** | −493,33 | −203,67 | +206,81 | +139,48 | **+347,62** |
| **OOS** | **−855,73** | −1253,58 | −1040,55 | −1081,92 | **−1298,56** |

**In campione vince M5 e perde M1. Fuori campione vince M1 e perde M5.**
I due estremi si scambiano di posto; i tre in mezzo restano nell'ordine.

```
DAX   IS   migliore -> peggiore:   M5  M3  M4  M2  M1
DAX   OOS  migliore -> peggiore:   M1  M3  M4  M2  M5
Spearman IS -> OOS sul profitto:   -0,60
```

**Il 05/08 il DAX è stato spostato da M1 a M5 in forward** sulla base di *«440 trade: M1 −801
· M5 −79»*. Quel numero **è compatibile con la riga IS di questa tabella**, non con la riga
OOS. È stata una scelta in campione, applicata a soldi veri.

### Nasdaq — profitto per timeframe

| | M1 | M2 | M3 | M4 | M5 |
|---|---:|---:|---:|---:|---:|
| **IS** | **+469,39** | +156,74 | +171,84 | +63,75 | +156,84 |
| **OOS** | −550,34 | **−340,50** | −1567,25 | −1579,43 | −1513,57 |

```
Spearman IS -> OOS sul profitto:   +0,30
```

Qui l'ordine regge meglio, e dice una cosa netta: **M1 e M2 stanno davanti, M3/M4/M5 stanno
molto indietro** — in tutte e due le finestre.

## 🔴 Conseguenza immediata: l'esperimento che avevo proposto era sbagliato

Dopo la pagella del 06/08 avevo scritto che l'esperimento da fare era **spostare il trailing
delle aperture Nasdaq da M1 a M5**. I numeri dicono il contrario:

```
Nasdaq OOS:   M1 -550,34      M5 -1513,57
```

**M5 sarebbe costato quasi tre volte tanto.** Il 17% di movimento catturato il 06/08 è un
problema vero, ma **non si risolve allungando il timeframe del trailing.**

## ⚠️ Due limiti da tenere, prima di usare questi numeri

1. **Tutte e dieci le celle OOS sono negative.** Questa fase gira su `BREAKOUT` range 15, che
   è la geometria che abbiamo già bocciato. Stiamo ordinando *modi di perdere*: dire quale
   trailing è meno peggio su un sistema che perde **non dimostra** quale sia il migliore su
   un sistema che guadagna. **La fase va rifatta sul candidato validato** (`RETEST` 35/500/
   offset 200) prima di toccare qualsiasi cosa.
2. **Le metriche non concordano.** Sul DAX OOS il profitto e il payoff medio danno M1 come
   migliore, ma il **Profit Factor** dà M4 (0,828 contro 0,777 di M1). M1 perde meno in
   totale e per trade, ma con un rapporto peggiore fra vincite e perdite lorde. Quando due
   metriche non concordano, la cella non è un vincitore: è un pareggio.

**Quindi: non si cambia niente sul trailing, né sul DAX né sul Nasdaq.**

---

# FASE L — da dove si prende il range. La vecchia C6.

Configurazione: `RETEST`, buffer 500, offset 200, gestione accesa, 1%.
Sweep su `InpRangeMode` × `InpRangeMinutes` {15, 35}.

```
0 = OPENING   primi N minuti DOPO l'apertura
1 = PREV      massimo/minimo dei 60 minuti PRIMA
2 = PREVBAR   massimo/minimo della candela precedente su H1
```

## ✅ Un controllo di coerenza che passa

Con `RangeMode` 1 e 2 le righe a range 15 e a range 35 sono **identiche al centesimo**.
È **giusto che lo siano**: `InpRangeMinutes` lo usa solo `OPENING`. Il rilevatore delle
"righe identiche = un ramo che non gira" qui si accende come previsto, e conferma che
i tre rami fanno davvero cose diverse.

## 🔴 Nasdaq, fuori campione: la configurazione ACCESA è la peggiore delle tre

| RangeMode | range | Profit | PF | Equity DD % |
|---|---:|---:|---:|---:|
| 0 OPENING | 35 | **+107,19** | 1,022 | 7,88% |
| 0 OPENING | 15 | −681,90 | 0,886 | 11,70% |
| 1 PREV | — | −1600,74 | 0,798 | 17,35% |
| **2 PREVBAR** | — | **−2444,14** | **0,665** | **26,29%** |

**`ABTG_Nasdaq_Apertura_US` e `ABTG_Nasdaq_Apertura_US_Ottimizzato` girano
`ABTG_DEF_RANGE_MODE 2`** — verificato nel codice. Cioè **PREVBAR, la riga peggiore della
tabella**: −2444 € fuori campione, Profit Factor 0,665, drawdown **26,29%** al rischio
dell'1%. Al 2%, che è quello che gira, il drawdown va oltre il 50%.

**C6 è chiusa, ed è la sesta bocciatura.** L'ultima ipotesi in piedi sul Nasdaq d'apertura
non solo non salva niente: è la configurazione **peggiore** delle tre, e sta girando adesso.

## 🔴 La tabella completa: l'ordine si ROVESCIA su tutti e due i simboli

Gli 8 CSV sono arrivati. Profitto, con Profit Factor e drawdown fuori campione:

### DAX

| cella | IS | OOS | PF OOS | DD OOS |
|---|---:|---:|---:|---:|
| **OPENING 35** ← quello ACCESO | −9,02 | **+1198,79** | **1,237** | 10,49% |
| OPENING 15 | −1241,91 | −318,43 | 0,950 | 13,30% |
| PREVBAR | +380,16 | −748,39 | 0,883 | 14,93% |
| PREV | **+509,69** | **−886,05** | 0,861 | 15,56% |

```
IS   migliore -> peggiore:   PREV > PREVBAR > OPENING 35 > OPENING 15
OOS  migliore -> peggiore:   OPENING 35 > OPENING 15 > PREVBAR > PREV
Spearman IS -> OOS:          -0,80
```

### Nasdaq

| cella | IS | OOS | PF OOS | DD OOS |
|---|---:|---:|---:|---:|
| OPENING 35 | −261,87 | **+107,19** | 1,022 | 7,88% |
| OPENING 15 | −702,75 | −681,90 | 0,886 | 11,70% |
| PREV | +106,12 | −1600,74 | 0,798 | 17,35% |
| **PREVBAR** ← quello ACCESO | **+434,08** | **−2444,14** | **0,664** | **26,29%** |

```
IS   migliore -> peggiore:   PREVBAR > PREV > OPENING 35 > OPENING 15
OOS  migliore -> peggiore:   OPENING 35 > OPENING 15 > PREV > PREVBAR
Spearman IS -> OOS:          -0,80
```

## Quello che questa tabella dimostra

**Su tutti e due i simboli, la classifica in campione è quasi esattamente il contrario di
quella fuori campione. Spearman −0,80 su entrambi, lo stesso numero.**

Non è una sfumatura, è un ribaltamento:

- **Sul DAX**, scegliere sull'IS avrebbe portato a `PREV`. Fuori campione `PREV` fa
  **−886,05** contro i **+1198,79** della cella che il DAX già usa. **Duemilaottantacinque
  euro di differenza**, presi scegliendo sulla finestra sbagliata.
- **Sul Nasdaq**, `PREVBAR` è la **migliore in campione (+434,08, PF 1,096)** e la
  **peggiore fuori campione (−2444,14, PF 0,664, DD 26,29%)**. Ed è **la configurazione che
  gira in forward adesso.**

## 🔑 E qui le due fasi di stanotte si saldano

| decisione presa in forward | come appare in campione | com'è fuori campione |
|---|---|---|
| DAX: trailing `PREVBAR M5` (dal 05/08) | il migliore dei cinque | **il peggiore dei cinque** |
| Nasdaq: `RangeMode PREVBAR` | il migliore dei quattro | **il peggiore dei quattro** |

**Due configurazioni scelte su misure in campione, due volte la peggiore fuori campione.**
Non è sfortuna: è la firma del sovradattamento, e adesso l'abbiamo misurata due volte in una
notte con due parametri che non c'entrano niente l'uno con l'altro (Spearman −0,60 e −0,80).

## ✅ Il candidato DAX ne esce rafforzato

`RangeMode` non è una leva da tirare: **il DAX sta già sulla cella migliore delle quattro**,
e di parecchio. La configurazione validata regge il quarto esame, e per la terza volta
riproduce lo stesso numero al centesimo — **+1198,79 · PF 1,237 · DD 10,49%**.

---

# Cosa si fa

## Deciso

1. **Niente cambi al trailing**, su nessun EA. La misura che aveva motivato il passaggio a M5
   sul DAX era in campione e fuori campione si inverte. Il forward attuale resta com'è
   finché la fase non è rifatta sulla geometria giusta.
2. **L'apertura Nasdaq è chiusa come ricerca.** Sei test indipendenti falliti, e la
   configurazione accesa è la peggiore misurata: PF 0,665 e DD 26,29% all'1%.
   **Va spenta o portata a rischio simbolico. È una decisione di Claudio, non un test.**

## Da fare

3. **Rifare la FASE I sul candidato** `RETEST` 35/500/offset 200 — ordinare i trailing su un
   sistema che perde non dice quale vince su un sistema che guadagna.
4. **Mancano due CSV**: `DAX_L_rangemode_OOS` e `NASDAQ_L_rangemode_IS`.
5. **Errore mio nella progettazione della fase**: ho pinnato `InpBufferPoints = 300` su
   entrambi i simboli. È il buffer del Nasdaq live; il DAX live usa **200**. Le righe DAX
   della FASE I non corrispondono quindi a nessuna configurazione reale. Non cambia le
   conclusioni (il confronto fra timeframe è interno alla stessa configurazione), ma va
   corretto prima di rifarla.
