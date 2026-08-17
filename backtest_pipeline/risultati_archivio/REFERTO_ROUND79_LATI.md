# ⚔️ R79 — **NON È UN LATO.** Su USDJPY perdono tutti e due. E su GBPUSD ne esce una conferma inattesa.

_Prova dell'ipotesi 2 di R78. Criteri congelati in `prove/R79_PTE_LATI_USDJPY.txt`
prima di aprire lo zip._

**Banco:** `ABTG_PTE` · H1 · **OHLC** · **IS `2000.01.01 → 2013.03.31`** ·
**OOS `2013.04.01 → 2026.06.30`** · pin della sedia viva (`TP1 0,5`, `TP2 2,0`) ·
rischio 1%. **8 celle**: `AllowLong{0,1}` × `AllowShort{0,1}` × `buffer{5,25}`.
Igiene: 4 CSV su 4, 8 celle su 8, cancelli verificati.

---

## 1. ✅ DUE CONTROLLI DI IGIENE, ED È IL SECONDO QUELLO CHE CONTA

**Il primo, quello che avevo chiesto:** la cella `AllowLong=0 + AllowShort=0`
dà **0 trade e 0 profitto** su entrambi i simboli e entrambi i buffer. **I flag
funzionano davvero.** ✅

**Il secondo, che il round si è portato dietro da solo — e vale di più:**

| | LONG solo | + | SHORT solo | = | somma | contro **entrambi** |
|---|---:|---|---:|---|---:|---:|
| USDJPY buf 5 | −2.997 | | −2.076 | | **−5.073** | **−5.012** |
| USDJPY buf 25 | −3.202 | | −515 | | **−3.717** | **−3.671** |
| GBPUSD buf 5 | −620 | | −1.514 | | **−2.134** | **−2.125** |
| GBPUSD buf 25 | +1.584 | | +2.945 | | **+4.529** | **+4.576** |

> ### 🎯 **I due lati sono ADDITIVI: la somma torna con lo scarto dell'1%.**
>
> Vuol dire che `InpMaxPositions = 1` **quasi non morde** — i due lati raramente
> si tolgono il posto a vicenda — e quindi **la scomposizione è legittima**:
> quello che si legge nei lati separati è davvero quello che succede dentro la
> sedia intera, non un artefatto del limite di posizioni.

## 2. 🔴 USDJPY — **L'IPOTESI È MORTA: NON C'È UN LATO COLPEVOLE**

| buffer | lato | **OOS** | PF | **DD** | n |
|---:|---|---:|---:|---:|---:|
| 5 | entrambi (**la sedia viva**) | **−5.012** | 0,935 | **20,04%** | 456 |
| 5 | SOLO LONG | **−2.997** | 0,924 | 11,48% | 224 |
| 5 | SOLO SHORT | **−2.076** | 0,948 | 11,52% | 232 |
| 25 | entrambi | −3.671 | 0,928 | 15,66% | 482 |
| 25 | SOLO LONG | **−3.202** | 0,884 | 9,85% | 236 |
| 25 | SOLO SHORT | **−515** | 0,979 | **7,68%** | 246 |

**Otto celle su otto negative. Nessun lato si salva, con nessuna delle due
tarature.** L'ipotesi *"un lato porta tutta la perdita e basta spegnerlo"* —
scritta prima dei numeri — **è smentita.**

📌 L'unica cella che ci va vicino è **`SOLO SHORT / buffer 25`: −515 con
PF 0,979 e DD 7,68%**, praticamente in pari. **Ma è negativa, e la clausola di
segno congelata dopo R77 dice che non si promuove niente che perde.** Applicata.

🔍 **Una cosa che il round mostra e che non so spiegare** — dichiarata come
`[INCERTO]`: su USDJPY il buffer 25 **peggiora il long** (−2.997 → −3.202) e
**migliora molto lo short** (−2.076 → −515). Sui due lati fa cose opposte. Non
lo invento: serve il per-trade.

📉 **E un fatto di RISCHIO che vale comunque** (regola B): separare i lati
**dimezza il drawdown**, da 20,04% a 11,5%, e con buffer 25 arriva a **7,68%**.
Su una sedia che perde è una consolazione, ma è un fatto misurato.

## 3. 🟢 GBPUSD — **E QUI ESCE UNA CONFERMA CHE NON CERCAVO**

Il controllo doveva solo dire *"è del motore o del simbolo?"*. Ha detto di più:

| buffer | lato | **OOS** | PF | **DD** |
|---:|---|---:|---:|---:|
| **5** | SOLO LONG | −620 | 0,984 | 9,71% |
| **5** | SOLO SHORT | −1.514 | 0,957 | 14,18% |
| **25** | SOLO LONG | **+1.584** | **1,066** | **6,55%** |
| **25** | SOLO SHORT | **+2.945** | **1,140** | **7,87%** |

> ### 🎯 **Col buffer vivo (5) perdono ENTRAMBI i lati. Col buffer 25 guadagnano ENTRAMBI.**
>
> **Il buffer 25 non "aggiusta un lato": raddrizza la struttura di tutte e due.**
> È la conferma più forte che R78 potesse ricevere, e arriva da una domanda
> diversa — **cioè da un controllo che non era stato costruito per confermarlo.**

📌 **Questo rafforza la candidata del duello** (`771332`, in campo dal 17/08):
non vince per un lato fortunato, **vince su entrambi i lati separatamente**.

## 4. ⚖️ LA RISPOSTA ALLA DOMANDA DI CONTROLLO: **È DEL SIMBOLO**

| | col buffer 25, i due lati |
|---|---|
| **GBPUSD** | **+1.584 e +2.945** 🟢 |
| **USDJPY** | **−3.202 e −515** 🔴 |

**Stesso motore, stessa taratura, stessa finestra, stesso modello: su un cambio
funzionano entrambi i lati, sull'altro nessuno dei due.**
👉 **Non è del motore. È del simbolo.** Terza conferma indipendente della
regola C dopo R78 (i ribaltamenti opposti) e R74 (il Dow).

---

## 5. 🚦 VERDETTO

> **1. 🔴 Su USDJPY l'ipotesi del lato colpevole è MORTA: 8 celle su 8 negative,
> nessun lato si salva con nessuna taratura.**
>
> **2. 🟢 Su GBPUSD col buffer 25 guadagnano ENTRAMBI i lati — la candidata del
> duello ne esce rafforzata da un controllo che non era stato fatto per lei.**
>
> **3. ⚖️ Il problema è del SIMBOLO, non del motore.**
>
> **4. ✅ E la scomposizione è pulita: i lati sono additivi all'1%.**

## 6. 🪑 DOVE SIAMO CON LA SEDIA `771323`

| round | cosa ha misurato sull'OOS 13 anni |
|---|---|
| **R77** (TP1=0) | **0 celle positive su 28** |
| **R78** (TP1=0,5, config vera) | **1 su 14**, e quell'una fa +590 in tredici anni |
| **R79** (i lati) | **0 su 8** |

**Tre round indipendenti, ~50 configurazioni, tutte negative su tredici anni.**
L'unica cosa che difende quella sedia è **R73**: due anni a tick reali, **+979**.

🎯 **La mia lettura, detta chiaramente:** l'ipotesi che questo motore abbia un
edge su USDJPY **regge sempre meno**, e resta **una sola domanda tecnica**
prima di poterlo dire: **in quali regimi funziona?** (ipotesi 3 di R78).
La macchina esiste già — le quattro finestre di R50/R56/R59.

**Se anche la prova di regime non produce un "funziona nel regime X" pulito,
la domanda smette di essere tecnica**: una sedia che ha bisogno di tredici anni
per perdere soldi sta occupando un posto, e i posti non sono infiniti.

🔴 **Ma questo round è OHLC e non tocca niente**: la decisione resta di Claudio,
e arriva dopo R80.

## 7. ➡️ R80 — LA PROVA DI REGIME SU `PTE USDJPY`

**L'ultima domanda tecnica che dobbiamo a questa sedia.** Quattro finestre già
definite (toro / orso / laterale / crollo), macchina già scritta e collaudata,
e i criteri di R59 già congelati (n≥20 verdetto pieno, 8-19 sospeso sul merito
ma **mai sul rischio**).

Due celle bastano: **la sedia viva** (`buf 5 / entrambi i lati`) e la
**meno peggiore** di R79 (`buf 25 / solo short`). Se una delle due è
chiaramente positiva in due regimi su quattro, la sedia ha una ragione di
esistere; se no, non ce l'ha.
