# 🔄 REFERTO ROUND 51 — il secondo ciclo del DAX: **RISERVA, non promozione**

_Girato il 14/08/2026 notte sul PC di backtest. `ABTG_DAX_Apertura_EU` v1.01,
D30EUR M5, tick reali, deposito 100.000, rischio 1%. 8 passate (4 celle × 2
finestre), **2 CSV su 2**. Criteri congelati a numeri non visti in
`prove/R51_REVERSE_TESI.md` §6 e in testa al file prova._

---

## 0. Igiene

Sweep gemello 772701/772702: **tutte e quattro le coppie identiche al
centesimo**, in tutte e due le finestre. Il banco è pulito, e l'EA v1.01 con
`InpAllowReverse` **compila e gira** — era la prima volta.

Nessun confronto di riproduzione disponibile: la cella misurata qui è quella
**live dal 06/08** (parziale 50% a 1R + BE), mentre il riferimento storico
`+1198,79 · PF 1,237 · DD 10,49%` (fase B1/M/I/L) era la stessa geometria
**senza** parziale né BE. Il DD resta nella stessa fascia (10,49 → 10,75%), ma
non è una riproduzione e non la chiamo così.

---

## 1. Il tabellone

### In campione (IS)
| reverse | Profit | PF | **DD** | Trades | payoff | Recovery | Sharpe | **peggior giornata** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **OFF** | **+3.157,87** | **1,085** | **7,20%** | 208 | 15,18 | 0,402 | 3,275 | **−1,07%** |
| ON | +2.763,47 | 1,046 | 8,79% | 313 | 8,83 | 0,283 | 1,827 | **−2,06%** |
| **Δ** | **−394,40** | −0,039 | **+1,59 pt** | **+105** | −42% | −30% | −44% | **×1,93** |

### Fuori campione (OOS)
| reverse | Profit | PF | **DD** | Trades | payoff | Recovery | Sharpe | **peggior giornata** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| OFF | +9.061,82 | 1,165 | 10,75% | 332 | 27,29 | 0,782 | 5,454 | **−1,08%** |
| **ON** | **+15.820,67** | **1,174** | **10,30%** | 527 | 30,02 | **1,412** | 5,578 | **−2,06%** |
| **Δ** | **+6.758,85** _(+74,6%)_ | +0,008 | **−0,45 pt** | **+195** | +10% | **+81%** | +2% | **×1,91** |

---

## 2. I criteri, uno per uno

### ✅ Criterio 1 — FREQUENZA: **passato, e non per poco**

Serviva **≥ 20** attivazioni del secondo ciclo in OOS. Ne sono uscite **195**
(527 − 332): quasi dieci volte la soglia. **Il round è conclusivo**, non
"misurato e basta".

> ⚠️ Precisazione onesta: `Trades` nel CSV di MT5 conta le uscite, e col
> parziale 50% una posizione ne produce più di una. Quindi 195 **sovrastima**
> il numero di cicli aggiunti. Anche dimezzandolo la soglia di 20 resta
> stracciata: la conclusione non dipende da questa ambiguità.

### ❌ La mia ipotesi 2 era sbagliata — **falsificata dai numeri**

Avevo scritto: _"stima onesta a priori: meno di 1 giorno su 5"_. La realtà è
**+59% di operatività** (527 contro 332), cioè il secondo ciclo si attiva
intorno a **3 giorni su 5**.

Perché ho sbagliato: ho stimato la frequenza sul solo caso _"il long si
riempie e va in stop"_. Ma il reverse parte **anche quando il primo LIMIT
scade inevaso** — che è il caso più comune di tutti, perché il retest spesso
non si riempie. È scritto nella tesi al §3 (_"i casi persi sono due, non
uno"_), e poi non l'ho messo nella stima. Errore mio nella previsione, non nel
codice.

### ⚠️ Criterio 3 — IL CANCELLO DEL DRAWDOWN: **passa fuori, fallisce dentro**

- **OOS: 10,30% ≤ 10,75%** → ✅ passa, e migliora anche il **Recovery Factor
  del +81%** (0,78 → 1,41): la curva fuori campione è più efficiente, non solo
  più lunga.
- **IS: 8,79% contro 7,20%** → ❌ non passa. In campione il reverse **toglie
  soldi (−394) e alza il DD di 1,6 punti**.

### ❌ Criterio 4 — REGOLA DEI DUE BANCHI: **FALLITO**

> _"IS e OOS devono andare nella stessa direzione. Un solo lato verde =
> riserva, non promozione."_

Le due finestre vanno in direzioni **opposte**, e non di poco:

| | profitto | DD | payoff dei trade aggiunti |
|---|---|---|---|
| **IS** | −394 | **peggiora** | **−3,76** per trade |
| **OOS** | +6.759 | migliora | **+34,66** per trade |

I trade del secondo ciclo sono **rossi dentro il campione e verdi fuori**. Non
c'è modo di leggerlo come un unico comportamento.

### ➖ Criteri 2 e 5 — non misurabili qui, come dichiarato prima del lancio

Il PF dei **soli** trade del secondo ciclo (criterio 2) e la **simmetria**
long/short di ritorno (criterio 5) richiedono il giro per-trade, che è il
criterio 6 e si fa **solo se passa tutto**. Non è passato tutto. Non si spende.

---

# ⚖️ VERDETTO

> ## RISERVA. Non promozione. `InpAllowReverse` resta **false**.
>
> Il criterio 4 era scritto prima e dice esattamente questo. **Nessun cambio
> al forward, su nessun conto.**

---

## 3. 🚨 Il numero che pesa più di tutti gli altri

**Peggior giornata: da −1,07% a −2,06%. Raddoppia.** Su entrambe le finestre,
con la stessa precisione (×1,93 e ×1,91).

Era l'**ipotesi 3**, scritta prima di vedere un solo numero:

> _"nelle giornate a due cicli il rischio di giornata diventa 2R e la coda del
> drawdown si allunga anche con PF > 1. È per questo che il verdetto NON può
> venire dal PF."_

**Confermata al decimale.** E non è un dettaglio accademico:

- il pavimento FTMO è **−5% giornaliero**;
- a rischio 1% questa serie da sola passa da 1,07% a **2,06%** di coda
  giornaliera; alla taglia del 100k (0,65%) da ~0,70% a **~1,34%**;
- il conto 100k ha **27+ serie che condividono lo stesso pavimento**.

Il DD di equity **scende** mentre la peggior giornata **raddoppia**: non è una
contraddizione. Più trade rendono la curva più liscia nel lungo periodo (il
Recovery Factor lo dice), ma le **singole giornate diventano il doppio più
violente**. Per una prop, la seconda cosa conta più della prima.

## 4. 🔁 Il 30° ribaltamento

Il reverse è **negativo in campione** (−394, PF 1,085 → 1,046, Sharpe −44%) e
**fortemente positivo fuori** (+6.759, +74,6%). Chi avesse deciso guardando
l'IS l'avrebbe buttato via; chi guarda solo l'OOS lo metterebbe in produzione
domani mattina. **Nessuna delle due letture da sola è affidabile** — ed è
esattamente perché la regola dei due banchi esiste.

## 5. Cosa resta in mano — ed è parecchio

Questo round **non boccia l'idea di Claudio**: la mette in riserva con un
numero grosso attaccato. Fuori campione **+74,6% di profitto sulla stessa
cella, con DD più basso e Recovery Factor quasi raddoppiato** non è rumore.

Quello che manca per riaprire il caso è capire **perché l'IS è rosso**: 105
trade aggiunti che perdono in campione e 195 che guadagnano fuori. Il
per-trade lo direbbe — ma il criterio 6 dice "se passa tutto", e la disciplina
vale soprattutto quando il numero è bello.

**La cosa corretta da fare adesso**, e non costa nulla: il diritto di riaprire
il caso lo dà il **forward**, non un altro backtest sulla stessa finestra OOS —
che è già stata guardata otto volte (limite dichiarato nella fase M) ed è
ormai una seconda finestra in campione. `InpAllowReverse` è opt-in e default
false: **è già pronto per il giorno in cui una finestra nuova lo confermerà.**
