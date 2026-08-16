# 🎯 R67 — PTE: STOP E TARGET SONO ACCOPPIATI? **NO.** (16/08/2026)

_Nasce dalla caccia L: in `ABTG_PTE.mq5` **stop e target sono calcolati
indipendentemente** (`:329-330` vs `:338`). Leung & Li (arXiv:1411.5062)
provano su processo OU che il target ottimo e' **funzione monotona dello
stop**. Se e' vero da noi, il `TP2` migliore deve **spostarsi** quando cambia
la geometria dello stop._

**Banco:** GBPUSD H1, **OHLC**, deposito 100.000, rischio 1%.
**IS 2010.07.06 → 2016.11.26 · OOS → 2026.06.30** — **sedici anni**, grazie
allo storico misurato la sera stessa. 32 celle: `SLfromDoji` {0,1} ×
`SLbufferPips` {5,10,15,20} × `TP2_ATRmult` {1.5,2.0,2.5,3.0}.

---

## 1. 🔴 LA RISPOSTA: **il target ottimo NON si sposta. Ipotesi morta.**

Il criterio era scritto prima: _"se il `TP2` migliore **non si sposta** al
variare della geometria dello stop, l'idea muore li', a costo zero, e si e'
risparmiato un round intero."_

**Il `TP2` migliore in campione, gruppo per gruppo:**

| `SLfromDoji` | buffer | TP2 migliore | 2° | 3° | 4° |
|---|---:|---|---|---|---|
| 0 | 5 | **2,5** | 2,0 | 3,0 | 1,5 |
| 0 | 10 | **2,5** | 2,0 | 3,0 | 1,5 |
| 0 | 15 | **2,5** | 2,0 | 1,5 | 3,0 |
| 0 | 20 | **2,5** | 2,0 | 1,5 | 3,0 |
| 1 | 5 | **2,5** | 2,0 | 3,0 | 1,5 |
| 1 | 10 | **2,5** | 2,0 | 3,0 | 1,5 |
| 1 | 15 | **2,5** | 2,0 | 3,0 | 1,5 |
| 1 | 20 | **2,5** | 2,0 | 3,0 | 1,5 |

> ### 🎯 **`TP2 = 2,5` vince in TUTTI E OTTO i gruppi**, e persino l'ordine dei quattro valori e' quasi identico ovunque.
>
> **Il target non sa nulla dello stop, e non gli serve saperlo.** La tesi di
> Leung & Li non si trasferisce su questo motore: qui il target ottimo e'
> una costante, non una funzione della geometria dello stop.
>
> ✅ **Ipotesi falsificata a costo zero, come progettata.** Nessuna riga di
> codice scritta, nessun EA modificato, un round risparmiato.

**E lo si dice anche al contrario, che e' utile:** il `TP2 = 2,0` che gira
oggi in forward **non e' sbagliato** — e' il secondo di quattro in tutti e
otto i gruppi, e la differenza col 2,5 e' piccola. **Non c'e' niente da
correggere sul target.**

---

## 2. 🟠 IL PRIMO SOTTOPRODOTTO: **il buffer dello stop conta molto, e quello che gira e' il peggiore dei quattro**

La PTE in forward gira col default compilato (`ABTG_PTE.mq5:69` e
`Presets/ABTG_PTE_H4.set`): **`InpSLbufferPips = 5.0`**.

Confronto a parita' di tutto il resto (`SLfromDoji=0`, `TP2=2.0`):

| buffer | IS profit | **OOS profit** | PF OOS | **DD OOS** | pegg. giornata | n IS |
|---:|---:|---:|---:|---:|---:|---:|
| **5** ← *quello vivo* | **−1.068,04** | +3.931,52 | 1,074 | **13,38%** | **−1,71%** | **281** |
| 10 | +2.500,06 | **+7.412,60** | 1,172 | 9,50% | −1,56% | 311 |
| 15 | +1.991,35 | +5.141,17 | 1,133 | 9,78% | −1,45% | 322 |
| 20 | +5.123,28 | +2.734,29 | 1,077 | **10,05%** | −1,39% | **348** |

**Il buffer 5 e' il peggiore su quasi tutto**: unico IS-negativo del gruppo,
**drawdown piu' alto (13,38% contro 9,5-10%)**, peggior giornata piu' brutta.

🔍 **E c'e' un indizio meccanico**: col buffer 5 il motore fa **281 trade**
contro i 348 del buffer 20 — **il 24% in meno**. Uno stop piu' largo non
crea segnali: **[INFERITO]** con lo stop troppo stretto una parte degli
ingressi viene **rifiutata** (distanza minima del broker / stops level), e
la PTE viva starebbe **saltando in silenzio circa un quarto dei suoi
segnali**. Va verificato nel log, non dedotto da qui.

## 3. 🟠 IL SECONDO: `SLfromDoji` ha un'interazione fortissima col buffer

| `SLfromDoji=1` | OOS |
|---|---|
| buffer 5 | **−5.635 / −7.823** · DD **23-24%** |
| buffer 10 | **−5.895 / −7.642** · DD **21-22%** |
| buffer 15 | +2.189 / +3.788 · DD 13% |
| buffer 20 | **+6.595 / +8.004** · DD **8,7-9,3%** |

**Lo stop sulla doji e' un disastro con buffer piccolo e fra i migliori con
buffer 20.** Non e' un parametro indipendente: **e' la stessa manopola del
buffer, vista da un'altra parte.** Se un giorno si tocca uno, si tocca
l'altro.

---

## 4. 🔴 COSA NON SI FA CON QUESTI NUMERI

**Non si cambia niente in forward.** Regola di casa, e vale qui piu' che
altrove:

1. **E' OHLC, non un verdetto.** R57 ha misurato che cambiando solo il
   modello il segno si ribalta.
2. **La PTE e' una sedia viva**, e per giunta l'unico motore positivo in
   **tutti e quattro i regimi** di R50. Toccarla su uno screening sarebbe
   il modo piu' rapido di rompere la cosa migliore che avete.
3. **La scelta del metodo qui non promuove comunque**: la cella migliore in
   campione (`doji 0 / buf 20 / TP2 2,5`) fuori campione fa **+3.000,61 con
   PF 1,084** — **sotto la soglia di 1,10**. E il miglior OOS
   (`buf 10 / TP2 3,0`, +8.309) e' una cella che l'IS metteva a meta'
   classifica: **diciassettesima Spearman negativa su diciotto.**

## 5. 🚦 VERDETTO E COSA RESTA

> **L'ipotesi dell'accoppiamento TP/SL e' FALSIFICATA**: il target ottimo e'
> `2,5` in tutte e otto le geometrie di stop. Non c'e' niente da accoppiare,
> e il `2,0` che gira va bene. **Round chiuso, costo zero, come previsto.**
>
> **Ma il round ha trovato altro:** `InpSLbufferPips = 5` — il valore che
> gira in forward — e' il peggiore dei quattro testati su drawdown, peggior
> giornata e profitto in campione, e fa il **24% di trade in meno**.

**Il seguito giusto NON e' cambiare il parametro: e' misurarlo come si
deve.** Un round suo, con:
1. la **tesi scritta prima** (_"lo stop troppo stretto fa rifiutare gli
   ingressi e alza il DD"_) — e la **verifica nel log** che i rifiuti ci
   siano davvero;
2. **tick reali**, non OHLC;
3. gli altri simboli della famiglia (**Dow** e **USDJPY**, celle 7 e 9 di
   R52), perche' la PTE e' una famiglia e i verdetti sono di famiglia.

📌 E vale la pena ricordare che **due paper trovati dalla caccia L
giustificano meccaniche che gia' avete** (il tetto `InpMaxDistAtr`,
l'accoppiata TP+trailing) e **uno smonta un metro che usate**: Potters &
Bouchaud provano che il win rate _"does not give any information on the
reliability of the strategy"_.
