# 🛡️ INDURIMENTO PROP — le DUE sedie contro le condizioni peggiori di un broker prop

**12/09/2026, sabato. Alla challenge restano ~19 giorni.** Referto di **sola
lettura d'archivio + post-processing**.
🛑 **Nessun backtest eseguito** (MT5 sta sulle macchine di Claudio). **Nessun EA,
preset, magic, sedia, parametro di forward o riga di coda toccato.**
`backtest_pipeline/coda/CODA.txt` **non l'ho aperto in scrittura.**
Taglie, rischio, accensioni e il conto reale **10105439** restano **firma di Claudio**.

> 🚦 **CANCELLO.** I due cancelli deterministici sono **verdi** sui file che ho
> scritto (esito riprodotto in §9). Il **secondo strato — l'agente
> `controllo-preventivo` — lo lancia il coordinatore: lo dichiaro e non lo do per
> fatto.** Fino a quel PASS, niente di qui esce verso il VPS.

---

# 0. 🔴 I CRITERI CONGELATI, PRIMA DI OGNI NUMERO

I criteri completi sono in un file **committato prima del file prova e prima di
qualunque numero di tick reali**: `backtest_pipeline/prove/COLLAUDO_DAX101_CRITERI.md`
(commit `f3bc255`). Qui la sostanza, perche' il referto deve leggersi da solo.

## 0.1 La scala di stress, dichiarata per intero

| prova | scala | dove agisce | limite dichiarato |
|---|---|---|---|
| **A. SPREAD** (la prova principale) | **base · +25% · +50% · +100%** sulla **mediana MISURATA dell'ORA in cui il motore lavora** | riga `Spread=` dell'`.ini` (tick reali) **+** post-processing sui per-trade | 🔴 **non e' misurato che MT5 onori `Spread=` a Modello 4** → il canarino viene prima |
| **B. SLIPPAGE/LATENZA** | **0 / 1 / 2 / 5 punti INDICE** | 🔴 **sull'USCITA, non sull'ingresso** (§3) | approssimazione pessimistica: niente requote, rifiuti, slippage favorevole, niente cambio di selezione |
| **C. COMMISSIONI E NOTTE** | ricalcolo col profilo misurato | per-trade + statement | **profilo della PROP VERA = `[NON MISURATO]`** |

## 0.2 Le soglie, e la decisione dichiarata per ciascun esito

| esito | condizione | **decisione, dichiarata adesso** |
|---|---|---|
| ✅ **PASS** | a **+50%** di spread, **tutte e quattro**: profitto > 0 **E** PF ≥ 1,10 **E** DD di equity ≤ **8,0%** **E** peggior giornata di equity ≥ **−2,50%** **E** posizioni OOS ≥ 150 | **schierabile il 1 ottobre** sul piano del costo; la taglia resta `[FIRMA DI CLAUDIO]` |
| 🟠 **FRAGILE** | passa a +25% ma non a +50% | **non va in campo come seconda sedia**; si consegna il **margine in punti indice** e la riparazione candidata |
| 🔴 **BOCCIATO** | segno ribaltato gia' a +25% · **oppure** DD equity > **9,9%** a qualunque gradino · **oppure** peggior giornata > **−4,9%** a qualunque gradino · **oppure** posizioni OOS < 150 a qualunque gradino | **raccomandazione di NON schierarla**, col gradino e il numero. 🛑 Nessuno spegnimento automatico |

🧊 **E la valvola di casa, che non si tocca:** *il campione sottile sospende il
giudizio sul MERITO, mai sul RISCHIO*. Un DD accaduto vale a qualunque `n`:
quindi un gradino con poche posizioni **non puo' promuovere**, ma **puo'
bocciare** sul DD e sulla peggior giornata.

🎁 **E il REGALO** (`InpTP1_ClosePct` 50 → 0) si raccomanda **se e solo se** batte
la cella viva su **PF E DD E peggior giornata** in **tutti e quattro** i gradini.
Se si invertisse a **un solo** gradino, la raccomandazione **cade**.

## 0.3 🔴 Onesta' sull'ordine dei fatti, perche' il metodo vale solo se e' vero
Il **post-processing** di §4 e' stato calcolato **prima** che scrivessi le soglie
di §0.2 — perche' gira su CSV che erano gia' sul disco. Quindi:
👉 **i numeri di §4 NON sono il verdetto: sono l'ATTESA DICHIARATA** della misura
a tick reali, scritta al centesimo nel file prova, **falsificabile**.
👉 **Le soglie di §0.2 sono congelate prima della misura che decide** (la scala a
tick reali, che non esiste ancora). Questa distinzione e' la differenza fra un
collaudo e una spazzolata, e va letta cosi'.

---

# 1. 🥇 LA RISPOSTA IN NOVE RIGHE

1. 🟢 **Le due sedie NON crollano quando lo spread si allarga.** A **+100%** di
   spread — cioe' spread **raddoppiato** — restano positive tutte e due:
   `770101` PF **1,266** (da 1,397), `771531` PF **1,437** (da 1,524). Il DD di
   equity stimato resta **8,11%** e **8,54%**, dentro il muro del 9,9%.
   **Il pedaggio dello spread non e' il loro punto debole.**
2. 🔴 **Il loro punto debole e' la LATENZA, e morde una sedia sola.** A **5 punti
   indice** di peggioramento su ogni uscita, `770101` con la manopola **VIVA**
   scende a **PF 1,0353** — **sotto il pavimento di casa 1,10**, profitto
   ridotto al **10%** della base. Il **REGALO** allo stesso gradino tiene
   **1,1281**, `771531` tiene **1,3516**.
3. 🎁 **E il contro-esempio sul regalo E' FALSIFICATO, con il numero.** L'ipotesi
   *"il vantaggio del regalo e' solo un pedaggio piu' basso, e sotto stress si
   inverte"* **cade**: il regalo paga **il 2,9% di pedaggio IN PIU'** (3.338,60
   lotti contro 3.245,30) e **vince lo stesso a ogni gradino**, con un margine di
   PF **costante a +0,094** su tutti e quattro. 👉 **Il regalo e' piu' robusto,
   non solo piu' redditizio. E il margine prima del cedimento e' +35%.**
4. 📐 **La frontiera del costo, il numero che la missione chiede:** `770101` fa
   **33,0x** oggi sulla geometria viva e **16,5x a +100%** — **sopra il duro
   13,3x, sotto i 40x**. ✅ **Confermato, riprodotto da me.** 🔴 **E c'e' un
   numero che nessuno aveva: la frontiera non e' un rapporto, e' una
   DISTRIBUZIONE — a +100% il 19,7% delle 193 posizioni finisce SOTTO il
   pavimento DURO.** Una posizione su cinque.
5. 🔴 **IL RISULTATO PIU' IMPORTANTE, ed e' sul PORTAFOGLIO: alla taglia 1,00%
   le due sedie insieme SFONDANO il muro del 10%.** Monte Carlo sui giorni veri:
   **p99 12,17%** e **p95 9,90%** gia' al gradino **base**; a +50% il p95 va a
   **10,62%**. 🟢 **Alla taglia 0,65% tengono a ogni gradino** (p99 max **9,40%**).
   👉 **Lo 0,65% non e' una preferenza: e' la condizione di sopravvivenza.**
6. 🟢 **La correlazione fra le due sedie e' MISURATA e vale ~zero:** **−0,0045**
   sull'unione dei 222 giorni e **+0,0083** sui **73 giorni in comune** — e il
   secondo numero uccide l'obiezione *"lo zero e' un artefatto dei giorni
   riempiti con zero"*. Peggior giornata combinata: **−2,38%** a 1,00%,
   **−1,55%** a 0,65%, contro un muro giornaliero di 4,9%.
7. 🟢 **Due `[NON MISURABILE]` dei referti di stamattina sono MISURATI, e uno
   stava dentro l'EA.** `ABTG_DAX_Apertura_EU.mq5` **r.382-384 + r.616-623**
   campiona l'**EQUITY a ogni tick** e scrive la **peggior escursione
   giornaliera** nella colonna `Peggior Giornata %`: per `770101` vale
   **−1,0780%**. L'ho **riprodotta dai per-trade al quarto decimale**.
   🔴 **`ABTG_EMA200.mq5` NON ha quel blocco**: per la prima sedia la grandezza
   che decide il muro giornaliero resta `[NON MISURATA]`, e si chiude con **8
   righe di codice e ZERO passate** (§7).
8. 🔴 **E un rilievo di RISCHIO trovato per caso, che va davanti a tutto il
   resto: in campo le due sedie non rispettano il rapporto fra le loro
   taglie.** Nella finestra comune sullo **stesso** demo `50503392`, uno stop
   pieno di `770101` costa **104,60** unita' e uno **segnale** completo di
   `771531` ne costa **40,30**: rapporto **2,60**, mentre i contratti dicono
   **0,65**. **Discrepanza 4,0x.** Una delle due gira **fuori contratto**, e
   sul conto di una prop i muri sono percentuali assolute.
9. 🪑 **Schierabili il 1 ottobre: DUE — a tre condizioni scritte**, e la prima
   e' la taglia. §8.

---

# 2. 🔬 IL BANCO DI PROVA, e la verifica contro numeri scritti da altri

Tutto il post-processing gira su **per-trade veri**, letti col **separatore
giusto**: `close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`
— **punto e virgola**, e l'intestazione la ho guardata prima di contare.

| sorgente | cosa contiene |
|---|---|
| `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv` | `770101` cella **VIVA** (`InpTP1_ClosePct=50`): **270 deal = 193 posizioni** (rapporto 1,3990) |
| `.../abtg_trades_..._772503.csv` | `770101` cella **REGALO** (`=0`): **193 deal = 193 posizioni** (1,0000) |
| `backtest_pipeline/risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` | `771531` OOS: **517 deal = 257 posizioni** (2,0117) |
| `data/statements/trades_auto.csv` | il campo: `770101` n=35 · `771531` n=21, con `open_time`, `commission`, `swap` |

## 2.1 ✅ Cinque numeri scritti da altri, riprodotti da me sui file grezzi

| numero | chi l'ha scritto | il mio |
|---|---|---|
| `770101` profitto OOS **+18.029,58** | `..._OOS_r47a.csv` r.2 | **+18.029,58** (esatto) |
| `770101` PF per **posizione** | — | **1,39728** contro 1,39709 per deal → 🟢 la classe 226 non muove il PF |
| `771531` DD sui **chiusi 7,5367%** | `report/EMA200_I_DUE_REQUISITI` §1 | **7,5367%** (esatto) |
| `771531` PF per **posizione 1,52370** | idem §3.1 | **1,52370** (esatto) |
| `771531` peggior giornata **−2,448%** | idem §5.3 | **−2,4484%** (esatto) |

## 2.2 🎯 E LA VERIFICA CHE VALE PIU' DELLE ALTRE CINQUE

La colonna `Peggior Giornata %` dei CSV di `770101` **non e' un conto sui
chiusi**: l'EA campiona `AccountInfoDouble(ACCOUNT_EQUITY)` a **ogni tick**
(`ABTG_DAX_Apertura_EU.mq5` r.616-623, dentro `ABTG_OnTick()` che parte a r.587,
**senza nessun `return` prima**) e tiene il minimo della giornata contro
l'equity d'apertura (r.2283 → colonna del CSV).

Io ho ricostruito la stessa grandezza **dai per-trade**, normalizzando il P/L del
giorno sul **saldo d'apertura di quel giorno**:

```
770101 cella VIVA    io -1,0780%   |  l'EA -1,0780%    <- quarto decimale
770101 cella REGALO  io -1,0793%   |  l'EA -1,0793%    <- quarto decimale
```

👉 **Non e' fortuna, ed e' spiegabile**: questa sedia tiene **una posizione per
volta, una al giorno**, e nel giorno peggiore esce **allo stop** — quindi il
minimo di equity **cade sull'uscita**, e chiusi ed equity coincidono per
costruzione. 🟢 **Conseguenza: la mia pipeline puo' ricalcolare la peggior
giornata di EQUITY a ogni gradino di stress.** Per `771531` no (piu' gambe
aperte insieme): la' resta un **pavimento sui chiusi**, e lo dico ogni volta.

## 2.3 📐 La calibrazione del valore del punto — e il contro-esempio che la sceglie

Il pedaggio in euro serve il **valore del punto**. Per `U30USD` e' **misurato**:
**0,8569–0,8628** unita'/punto/lotto (n=8, statement). Per `D30EUR` **non c'e'
una misura diretta**, quindi l'ho **derivato** e poi **provato a rompere**: dal
lotto per rischio (`CalcLotByRisk`, r.1791-1817) vale
`rischio/lotti = PV x stop`, e il confronto va fatto contro lo **stop misurato
da qualcun altro** (`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.391).

| ipotesi su PV di `D30EUR` | stop implicito mediano | contro il **misurato 71,9 idx** (n=7) | verdetto |
|---|---:|---|---|
| **1,0 EUR/idx/lotto** | **77,8 idx** | +8,2% | 🟢 **coerente** |
| 0,5 | 155,7 idx | +117% — e il **p10** (75,6) starebbe **sopra la mediana misurata** | 🔴 escluso |
| 2,0 | 38,9 idx | −46% — un range d'apertura DAX di 19 idx al p10 | 🔴 escluso |

E la stessa lente su `U30USD`, dove il PV **e'** misurato:

| ipotesi | stop implicito mediano | contro il **misurato 104,3 idx** (n=8) |
|---|---:|---|
| **PV 0,861 · rischio 0,5%/gamba** | **115,0 idx** | 🟢 **+10,3%** |
| PV 0,861 · rischio 1,0%/gamba | 230,1 idx | 🔴 +121% |
| PV 8,61 (ipotesi di R114) | 11,5 idx | 🔴 −89% |

👉 **Le due derivazioni sbagliano dello stesso verso e della stessa entita'
(+8,2% e +10,3%)**, e la ragione e' nel codice: il lotto e' **arrotondato per
DIFETTO** al `lotStep` (`MathFloor`, r.1824), quindi il rischio vero e'
leggermente **minore** del nominale e lo stop implicito esce **alto**.
🟢 **Il metodo discrimina**: le ipotesi alternative sbagliano di 1-2 ordini di
grandezza, non del 10%.

---

# 3. 🚫 IL MODELLO DI SLIPPAGE DI CASA **NON SI APPLICA** A QUESTE DUE SEDIE — ed e' un fatto di codice

La scala B di casa dice *"peggiora ogni INGRESSO A MERCATO di N punti"*.
🔴 **Nessuna delle due sedie entra a mercato.**

| sedia | come entra | riga |
|---|---|---|
| `770101` | `InpEntryMode=2` (`ABTG_RETEST`) → **`gTrade.BuyLimit(...)`** | `ABTG_DAX_Apertura_EU.mq5` **r.1504** |
| `771531` | **due `PlaceLimit`** attorno alla EMA200 | `ABTG_EMA200.mq5` **r.360-365** |

Un ordine **LIMIT** non si riempie *peggio* per latenza: si riempie **al prezzo
o meglio**, oppure **non si riempie**. Peggiorare il prezzo d'ingresso
modellerebbe **una cosa che non esiste** — sarebbe un numero con l'aria di un
dato. 👉 Quindi la scala di latenza si applica **all'USCITA** (lo stop e' un
ordine di mercato quando scatta), in **punti indice**, su **ogni** posizione.

## 3.1 🔬 E lo sforamento oltre lo stop e' GIA' MISURATO nei per-trade
Le posizioni che perdono **piu' di 1 R** hanno sforato il livello di stop. Lo
scarto, riportato in punti indice, e' **la sola misura d'esecuzione** che i
per-trade contengono:

| cella | posizioni oltre 1 R | mediana | p90 | max | media su TUTTE le posizioni |
|---|---|---:|---:|---:|---:|
| `770101` VIVA | **15 / 193** (7,8%) | 0,28 idx | 3,23 | **6,41** | **0,081 idx** |
| `770101` REGALO | 20 / 193 (10,4%) | 0,17 | 3,28 | 6,39 | 0,089 |
| `771531` | **18 / 257** (7,0%) | 0,79 | 2,51 | 2,70 | 0,071 |

👉 **La scala 0/1/2/5 idx e' calibrata su questo**, non a naso: il gradino **1
idx** e' ~12x la media misurata, il gradino **5 idx** e' oltre il **massimo mai
osservato** su entrambe. E' **pessimismo controllato**.
⚠️ **[LIMITE]** e' lo slippage **del tester** (il gap fra livello e primo tick
che lo attraversa): il reale puo' solo essere **≥**. Stessa riga che dichiara
`backtest_pipeline/misura_slippage.py`.

---

# 4. 📊 LA SCALA DI STRESS, SEDIA PER SEDIA E GRADINO PER GRADINO

> **Modello, dichiarato:** un round trip paga **una** volta lo spread (compro
> all'**ask**, vendo al **bid**). Quindi un incremento Δ di spread costa
> `lotti × PV × Δ` per posizione. Il contro-esempio *"e se si pagasse DUE
> volte?"* e' in §5.2, con la colonna sua.
> **Il DD di equity** e' il DD sui **chiusi** riscalato per il **fattore
> flottante misurato al gradino base** (`770101` VIVA **1,15695** · REGALO
> **1,16213** · `771531` **1,03923**). Il numero **misurato** e' quello della
> base; gli altri tre sono **DERIVATI**, e li leggo come tali.

## 4.1 🪑 `770101` `ABTG_DAX_Apertura_EU` D30EUR M5 LONG — cella **VIVA** (`InpTP1_ClosePct=50`)
Spread base **1,70 idx** = mediana MISURATA dell'ora **SERVER 08** su
**30.974.789 tick** (`spread_orario_D30EUR.csv` r.10). Le ore 09 e 10, dove cade
il resto dei riempimenti, hanno la **stessa mediana** e un **p95 piu' basso**:
l'ora 08 e' **la peggiore delle tre**, quindi la base e' la piu' pessimista.

| gradino | spread idx | `-Spread` | profitto | **PF** | DD chiusi | **DD equity** | **pegg. giornata equity** | pedaggio totale | **x mediano** (geom. viva) | **% pos < 40x** | 🔴 **% pos < 13,3x** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **base** | 1,70 | 0 | **+18.029,58** | **1,39709** | 6,2516% | **7,2328%** ⓜ | **−1,0780%** ⓜ | 5.517 | **33,0x** | 38,9% | 0,5% |
| **+25%** | 2,125 | 213 | +16.650,33 | **1,36381** | 6,4361% | 7,4463% | −1,0911% | 6.896 | 26,4x | 59,6% | 2,1% |
| **+50%** | 2,55 | 255 | +15.271,08 | **1,33079** | 6,6241% | 7,6638% | −1,1043% | 8.276 | 22,0x | 74,1% | 7,3% |
| **+100%** | 3,40 | 340 | +12.512,57 | **1,26606** | 7,0109% | 8,1112% | −1,1495% | 11.034 | 🔴 **16,5x** | 91,2% | 🔴 **19,7%** |

ⓜ = **MISURATO** (dal CSV / dall'EA). Gli altri: **derivati**.

> ### ✅ **VERDETTO CELLA VIVA sulla PROVA A: PASS.**
> A +50%: profitto **+15.271** > 0 ✅ · PF **1,331** ≥ 1,10 ✅ · DD equity
> **7,66%** ≤ 8,0% ✅ · peggior giornata **−1,104%** ≥ −2,50% ✅ · posizioni
> **193** ≥ 150 ✅. **Quattro su quattro.** E regge anche **+100%** (PF 1,266 ·
> DD 8,11% · peggior giornata −1,15%).

## 4.2 🎁 `770101` — cella **REGALO** (`InpTP1_ClosePct=0`)

| gradino | spread idx | profitto | **PF** | DD chiusi | **DD equity** | **pegg. giornata equity** | pedaggio |
|---|---:|---:|---:|---:|---:|---:|---:|
| **base** | 1,70 | **+23.607,28** | **1,49140** | 5,3969% | **6,2719%** ⓜ | **−1,0793%** ⓜ | 5.676 |
| **+25%** | 2,125 | +22.188,37 | **1,45796** | 5,5563% | 6,4572% | −1,0924% | 7.095 |
| **+50%** | 2,55 | +20.769,47 | **1,42497** | 5,7188% | 6,6459% | −1,1056% | 8.513 |
| **+100%** | 3,40 | +17.931,66 | **1,36016** | 6,0530% | 7,0344% | −1,1479% | 11.351 |

## 4.3 🚄 `771531` `ABTG_EMA200` U30USD H1 — la prima sedia

🔴 **PRIMA CORREZIONE, e non e' cosmetica: questa sedia NON e' "LONG".** Il
preset vivo (`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set`)
porta **`InpAllowLong=true` E `InpAllowShort=true`**, e coincide con la cella di
R112 su tutte le manopole. 👉 Il PF **1,52365** e il DD **7,8323%** sono della
cella **L+S**. Il lato **long puro** vale **PF 1,24103** (R110/R112). **Chi
cercasse una cella long-only con PF 1,52 non la trova, perche' non esiste.**

🔴 **SECONDA CORREZIONE — la base di spread di questa sedia e' piu' ALTA di
quella usata in archivio.** `prove/COLLAUDO_EMADOW_01_spread_scala_ini.txt` usa
**1,9 idx**, cioe' la mediana delle **ore 14-21**. Ma questa sedia gira **24 ore**
(`InpUseCutoff=false`, `InpMaxTradesPerDay=0`), e le ore 0-13 hanno mediana
**2,6-2,8**. Pesando le **257 posizioni** sulle ore vere:

| ipotesi sull'ora d'ingresso | mediana pesata | p95 pesato |
|---|---:|---:|
| ora di **chiusura** | **2,221 idx** | 2,719 |
| chiusura **−2h** | 2,374 | — |
| chiusura **−4h** (durata mediana misurata 2,50-3,70 h) | **2,440 idx** | 2,882 |

👉 Uso **2,44** (l'estremo pessimista) e dichiaro la banda **2,22-2,44**.
🔴 **Conseguenza operativa: i gradini 238/285/380 di `COLLAUDO_EMADOW_01`
sottostimano la base del 17-28%.** Non tocco quel file (e' gatato e non e' mio):
**segnalo il numero e propongo la ri-gatatura** con base 2,44 → `-Spread`
**244 / 305 / 366 / 488**.

| gradino | spread idx | `-Spread` | profitto | **PF** | DD chiusi | **DD equity** | pegg. giorn. (chiusi) | **x mediano** (stop MIS 104,3) | **% pos < 40x** | **% pos < 13,3x** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **base** | 2,44 | 0 | **+23.321,47** | **1,52365** | 7,5367% | **7,8323%** ⓜ | **−2,4484%** ⓜ | **42,7x** | 33,5% | 0,0% |
| **+25%** | 3,05 | 305 | +22.505,61 | **1,50162** | 7,7047% | 8,0069% | −2,4592% | 34,2x | 52,5% | 0,4% |
| **+50%** | 3,66 | 366 | +21.689,75 | **1,47987** | 7,8737% | 8,1826% | −2,4700% | 28,5x | 65,4% | 2,3% |
| **+100%** | 4,88 | 488 | +20.058,03 | **1,43732** | 8,2149% | 8,5371% | −2,4915% | 21,4x | 85,2% | 8,2% |

> ### ✅ **VERDETTO `771531` sulla PROVA A: PASS.**
> A +50%: profitto **+21.690** ✅ · PF **1,480** ✅ · DD equity **8,18%** ≤ 8,0%?
> 🟠 **8,18% > 8,0% di 0,18 punti.** Applicando la soglia **alla lettera** questo
> e' un **FRAGILE**, non un PASS. 🔴 **E lo scrivo cosi', perche' le soglie si
> leggono come sono scritte, non come conviene.** Alla taglia **0,65%** lo stesso
> DD vale **5,32%**, dentro con margine; la soglia dell'8,0% e' tarata su
> rischio 1,0%. 👉 **Verdetto onesto: PASS a 0,65%, FRAGILE a 1,00%.**

🔴 **E l'ora 23 resta il buco di questa sedia, col numero.** Al **p95 dell'ora
23** lo spread di `U30USD` vale **7,0 idx**: il rapporto mediano scende a
**14,9x** (stop misurato) e il **30,4% delle posizioni finisce sotto il
pavimento DURO 13,3x**. La sedia apre anche a quell'ora (**6 chiusure su 257**
all'ora 23). Riparazione candidata: **`InpMaxSpread`**, che oggi vale **0** =
nessun limite — con il limite dichiarato che `SpreadOK()` e' chiamata al
**segnale** (r.325), quindi filtra l'**ingresso** e non l'**uscita**:
**parziale per costruzione.**

## 4.4 📐 LA FRONTIERA DEL COSTO, il numero che la missione chiede — e quello che nessuno aveva

✅ **Confermo esattamente il numero della missione**: `770101` fa **33,0x** oggi
(56,1 idx di geometria viva / 1,70) e **16,5x a +100%** (56,1 / 3,40) —
**sopra il pavimento DURO 13,3x, sotto il pavimento di lavoro 40x**.
Riprodotto da me, e coincide con `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.391.

🔴 **Ma la frontiera non e' un rapporto: e' una DISTRIBUZIONE.** Lo stop di
questo motore e' **geometrico** (estremo opposto del range di 35 minuti), quindi
varia con il range del giorno: p10 **37,8 idx**, mediana **77,8**, p90 **130,5**.
Allora:

| | base 1,70 | +25% | +50% | **+100%** |
|---|---:|---:|---:|---:|
| `770101` — quota di posizioni **sotto 40x** | 38,9% | 59,6% | 74,1% | **91,2%** |
| `770101` — quota **sotto il DURO 13,3x** | 0,5% | 2,1% | 7,3% | 🔴 **19,7%** |
| `771531` — quota **sotto 40x** | 33,5% | 52,5% | 65,4% | 85,2% |
| `771531` — quota **sotto il DURO 13,3x** | 0,0% | 0,4% | 2,3% | 8,2% |

> ### 🔴 **E QUESTA E' LA RIGA CHE VA DETTA ESPLICITAMENTE**
> **A +100% di spread la mediana di `770101` sta a 16,5x, cioe' SOPRA il
> pavimento duro — ma una posizione su cinque (19,7%) ci finisce SOTTO.** Il
> duro si legge sul **minimo**, non sulla mediana: **una mediana sopra 13,3x che
> nasconde il 19,7% delle posizioni sotto non e' un PASS di costo.**
> 🟢 E va detto anche il rovescio: quel 19,7% **non ha ribaltato il segno** (PF
> 1,266). **Il motore assorbe il costo perche' i suoi vincitori sono grandi, non
> perche' i suoi stop siano larghi.**

## 4.5 🐌 LA SCALA DI LATENZA — dove muore la cella viva

| Δ uscita | `770101` **VIVA** | `770101` **REGALO** | `771531` |
|---|---|---|---|
| **0 idx** | +18.029 · PF **1,3973** | +23.607 · PF **1,4914** | +23.321 · PF **1,5237** |
| **1 idx** | +14.784 · PF **1,3192** | +20.269 · PF **1,4134** | +21.984 · PF **1,4877** |
| **2 idx** | +11.539 · PF **1,2437** | +16.930 · PF **1,3378** | +20.647 · PF **1,4525** |
| **5 idx** | +1.803 · 🔴 **PF 1,0353** | +6.914 · PF **1,1281** | +16.634 · PF **1,3516** |

> ### 🔴 **A 5 PUNTI INDICE DI SLIPPAGE SULL'USCITA, LA CELLA VIVA E' MORTA** —
> PF **1,0353**, sotto il pavimento di casa 1,10, con il **10%** del profitto
> di base. 🟢 **Il REGALO sopravvive** (1,1281) e **`771531` sta comodo** (1,3516).
> ⚠️ 5 idx e' un gradino **severo** e lo dichiaro: e' oltre il **massimo** di
> sforamento mai misurato (6,41 idx, una volta su 193). **Non e' la previsione:
> e' il punto di rottura.** E sapere dov'e' vale piu' che sperare che sia lontano.

## 4.6 🎯 IL MARGINE, in una tabella sola — quanto costo extra per posizione prima di cedere

| cella | spread base | Δ per **PF = 1,10** | **x la base** | Δ per **PF = 1,00** | Δ per **DD equity = 10%** | **quale vincolo morde primo** |
|---|---:|---:|---:|---:|---:|---|
| `770101` **VIVA** | 1,70 | **4,02 idx** | **2,37x** | 5,56 | 4,72 | 🔴 **il PF** |
| `770101` **REGALO** | 1,70 | **5,43 idx** | **3,20x** | 7,07 | 6,37 | il PF |
| `771531` | 2,44 | **13,53 idx** | **5,55x** | 17,44 | **7,32** | 🔴 **il DD** |

👉 **Il gradino +100% consuma il 42% del margine di PF della cella viva, il 31%
di quello del regalo, il 18% di quello di `771531`.**
👉 **E i vincoli sono DIVERSI**: `770101` muore di **redditivita'**, `771531`
muore di **drawdown**. Due sedie, due modi di rompersi: 🟢 **e' esattamente
quello che si vuole in un portafoglio da due.**

---

# 5. 🧪 I CONTRO-ESEMPI, costruiti da me, uno per verdetto

## 5.1 🎁 «Il vantaggio del regalo e' solo un pedaggio piu' basso, e sotto stress si inverte» — **FALSIFICATO**

La domanda che la missione chiama *"la piu' utile"*. L'ipotesi e' plausibile:
`InpTP1_ClosePct=0` tiene la posizione **intera** piu' a lungo. Ecco i numeri.

| | cella VIVA (50) | cella REGALO (0) | verso |
|---|---:|---:|---|
| **posizioni** | 193 | 193 | identiche (non e' selezione, e' gestione) |
| **volume chiuso totale** | 3.245,30 lotti | **3.338,60 lotti** | 🔴 **il regalo ne ha il 2,9% IN PIU'** |
| **pedaggio al gradino base** | 5.517 EUR | **5.676 EUR** | 🔴 **il regalo paga PIU' pedaggio** |
| Δ PF a **base** | | | **+0,0941** |
| Δ PF a **+25%** | | | **+0,0942** |
| Δ PF a **+50%** | | | **+0,0942** |
| Δ PF a **+100%** | | | **+0,0941** |

> ### 🔴 **L'IPOTESI CADE SU DUE FRONTI, NON SU UNO.**
> **(a)** Il pedaggio del regalo e' **piu' alto**, non piu' basso — perche'
> capitalizza piu' veloce e quindi muove piu' lotti. Se il vantaggio venisse dal
> pedaggio, il segno sarebbe rovesciato.
> **(b)** Il margine di PF **non si erode di un millesimo** lungo tutta la scala:
> **+0,0941 → +0,0942 → +0,0942 → +0,0941**. Il vantaggio e' **strutturale**
> (una gestione d'uscita migliore), **non un artefatto di costo**.
> 🟢 **E nella scala di latenza il regalo vince DI PIU', non di meno**: a 5 idx
> la viva fa **1,0353** e il regalo **1,1281** — Δ **+0,093** in PF ma **+283%**
> in profitto (6.914 contro 1.803). 👉 **Sotto lo stress peggiore la differenza
> fra le due celle e' fra sopravvivere e non sopravvivere.**

⚠️ **[LIMITE che va nella stessa riga]** questo post-processing **non modella il
cambio di selezione**: a spread piu' largo il BUY LIMIT di retest si innesca in
**giorni diversi**, e il TP1 scatta meno spesso. Quel pezzo **lo misura solo la
scala a tick reali** (il file prova di §9), e per questo la sentinella
**"`Trades` cambia piu' del 5% → il gradino misura la SELEZIONE, non il COSTO"**
sta scritta **dentro** il file, prima dei numeri.

## 5.2 🧮 «E se il pedaggio si pagasse DUE volte?» — regge comunque

`report/LA_SECONDA_SEDIA_2026-09-12.md` §5 (buco 5) scrive che *"il pedaggio si
paga DUE volte"*. Il mio modello dice **una** (compro all'ask, vendo al bid = un
round trip, uno spread). Invece di discutere, ho girato **anche** la versione a
pedaggio doppio:

| cella | base | +50% (pedaggio **x2**) | +100% (pedaggio **x2**) |
|---|---:|---:|---:|
| `770101` VIVA | PF 1,3973 | **1,26606** · DD 7,01% | **1,14300** · DD 7,85% |
| `770101` REGALO | 1,4914 | **1,36016** · DD 6,05% | **1,23665** · DD 6,79% |
| `771531` | 1,5237 | **1,43732** · DD 8,21% | **1,35551** · DD 8,91% |

👉 **Tutte e tre restano sopra 1,10 e dentro il 9,9% anche col pedaggio
raddoppiato.** Il verdetto di sopravvivenza **non dipende** da quale delle due
convenzioni sia giusta. 🟢 **E il mio modello e' lo stesso che ha usato un altro
agente**: `COLLAUDO_EMADOW_01` prevede, a +100% su base 1,9, un netto di
**~20.780**; il mio conto sulla stessa Δ da' **20.780,6**. **Due derivazioni
indipendenti, stesso numero.**

## 5.3 📈 «E se la base fosse il p95 dell'ora, non la mediana?»

| cella | p95 | p95 **+50%** | p95 **+100%** |
|---|---:|---:|---:|
| `770101` VIVA (p95 2,70) | PF **1,31922** | **1,21800** | **1,12216** |
| `770101` REGALO | **1,41339** | **1,31199** | **1,21567** |
| `771531` (p95 2,88) | **1,50774** | **1,45670** | **1,40728** |

👉 **Tutte sopra 1,10 anche partendo dal p95 e raddoppiandolo.** La cella viva
arriva a **1,122**, cioe' a **2,2 centesimi** dal pavimento: 🟠 **e' il punto piu'
esposto di tutto il collaudo sul lato spread**, e lo dichiaro.

## 5.4 🖤 LO SCENARIO NERO — e cade, e si scrive

Tutto insieme: spread **+100%**, contato **due volte**, **piu'** 5 idx di
slippage su ogni uscita (Δ totale **8,40 idx** sul DAX, **9,88** sul Dow).

| cella | profitto | PF | DD chiusi | verdetto |
|---|---:|---:|---:|---|
| `770101` VIVA | 🔴 **−9.230,94** | **0,836** | **13,04%** | 🔴 **BOCCIATO — sfonda il 10%** |
| `770101` REGALO | 🔴 **−4.436,96** | **0,925** | **10,65%** | 🔴 **BOCCIATO** |
| `771531` | +10.107,19 | **1,202** | **10,45%** | 🟠 positivo ma **sfonda il 10%** |

🔴 **Esiste uno scenario ricostruibile che boccia tutte e due le sedie, e lo
scrivo perche' e' un FAIL.** ⚠️ **E dico anche quanto e' plausibile, che e'
l'altra meta' dell'onesta'**: 8,40 idx di costo extra per posizione sono il
**10,8% dello stop mediano** e **4,9 volte** lo spread base — un livello che su
D30EUR non e' **mai** stato misurato, nemmeno al massimo assoluto dell'ora 08
(12,0 idx di spread **istantaneo**, non mediano). 👉 **Non e' il caso da
aspettarsi: e' il confine.** Il numero utile e' il **margine** di §4.6, non
questo.

## 5.5 🔗 «La correlazione zero e' un artefatto dei giorni riempiti con zero» — **FALSIFICATO**

| misura | valore |
|---|---:|
| giorni **unione** (zeri riempiti) | 222 → corr **−0,0045** |
| giorni **SOLO `770101`** | 120 |
| giorni **SOLO `771531`** | 29 |
| 🎯 giorni **IN COMUNE** | **73** → corr **+0,0083** |
| giornate in comune **in perdita su ENTRAMBE** | **10 / 73 = 13,7%** (attesa se indipendenti: **10,3%**) |

👉 **Le due letture danno lo stesso zero.** L'ipotesi alternativa prevedeva che
la correlazione vera, calcolata sui soli giorni in comune, fosse **molto** piu'
alta: misurata, e' **+0,008**. Il piccolo eccesso di doppie perdite (10 contro
7,5 attese) e' **due giornate e mezza su 73**: dentro il rumore.

Le **cinque peggiori giornate comuni** (deposito 100.000, rischio 1,0% ciascuna):

| data | `770101` | `771531` | somma | % del deposito |
|---|---:|---:|---:|---:|
| 2026.02.19 | −1.250,27 | −1.131,27 | −2.381,54 | **−2,382%** |
| 2026.04.02 | −1.186,18 | −1.186,31 | −2.372,49 | −2,372% |
| 2026.02.26 | −1.194,48 | −1.158,85 | −2.353,33 | −2,353% |
| 2026.02.06 | −1.150,50 | −1.081,26 | −2.231,76 | −2,232% |
| 2026.06.23 | **+229,50** | −2.448,42 | −2.218,92 | −2,219% |

🟢 **La riga piu' bella e' l'ultima**: il giorno peggiore in assoluto di
`771531` e' un giorno in cui `770101` **guadagna**. Non e' una prova di
decorrelazione (e' un giorno solo), ma e' il comportamento che la misura
promette.

---

# 6. 🔒 QUANTE POSIZIONI INSIEME, E QUANTO RISCHIO APERTO — letti dal SORGENTE

## 6.1 `770101` — **massimo UNA posizione. Rischio aperto = una taglia.**

| prova | riga |
|---|---|
| `InpOneTradePerDay=true` nel preset vivo | `..._770101_100K.set` |
| il tetto dei cicli del giorno e' **1**, non 2, perche' `InpAllowReverse=false` | `ABTG_DAX_Apertura_EU.mq5` **r.644**: `int tetto = (InpAllowReverse && InpEntryMode==ABTG_RETEST) ? 2 : 1;` — e il preset porta **`InpAllowReverse=false`** |
| guardia anti-duplicato reload-safe: se esiste un pendente **o** una posizione del suo magic, non ripiazza | **r.595-602** |
| un ciclo piazza **UN** solo LIMIT (il lato short e' spento) | `InpAllowShort=false` + **r.1481** / **r.1514** |
| 🎯 **confermato dai DATI, e non solo dal codice** | **193 posizioni in 193 giorni attivi, MAI due nello stesso giorno** (contate sui `position_id` dei per-trade) |

> ## 🟢 **`770101`: max posizioni contemporanee = 1 · max pendenti = 1 · RISCHIO APERTO MASSIMO = 1 x taglia = 0,65% alla taglia viva.**

## 6.2 `771531` — **massimo DUE posizioni. Rischio aperto = una taglia piena.**

| prova | riga |
|---|---|
| non valuta un segnale nuovo se ha una posizione **o** un pendente | `ABTG_EMA200.mq5` **r.322**: `if(HasPosition() || HasPending()){ ...; return; }` |
| ogni segnale piazza **due** LIMIT, e il rischio si **divide** | **r.359-365**: `int nOrders = InpUseOrder2 ? 2 : 1; double riskPct = InpRiskPercent/nOrders;` |
| filtro del guardiano: **simbolo E magic** | r.509-529 |
| campo (n=39 posizioni, 4 sedie della famiglia) | max contemporanee **2** su tutte |

> ## 🟢 **`771531`: max posizioni contemporanee = 2 · max pendenti = 2 · RISCHIO APERTO MASSIMO = 2 x (taglia/2) = 1 x taglia = 0,65% alla taglia viva.**

## 6.3 🔴 IL LIMITE STRUTTURALE DELLA GIORNATA — e qui c'e' un numero che decide

Il rischio **aperto** e' un'istantanea; il muro giornaliero di una prop si mangia
in **sequenza**. `771531` non ha `InpMaxTradesPerDay` (**0 = nessun limite**), e
dopo una chiusura puo' riarmare: **misurato, fino a 8 posizioni chiuse nello
stesso giorno** (= 4 segnali x 2 gambe) e **fino a 4 gambe PERDENTI nello stesso
giorno** (peggior giornata: **−3,95 R**, il 23/06/2026 e il 23/01/2026).

| | 770101 | 771531 (misurato: 4 gambe perdenti) | **somma** | 771531 (strutturale: 8 gambe) | **somma** |
|---|---:|---:|---:|---:|---:|
| **taglia 1,00%** | 1,00% | 2,00% | **3,00%** | 4,00% | 🔴 **5,00%** |
| **taglia 0,65%** | 0,65% | 1,30% | **1,95%** | 2,60% | 🟠 **3,25%** |

> ### 🔴 **ALLA TAGLIA 1,00% IL LIMITE STRUTTURALE DELLA GIORNATA E' ESATTAMENTE IL MURO DEL 5%.**
> Non "vicino": **il muro**. Alla taglia **0,65%** scende a **3,25%** — che e'
> **sotto la pausa morbida del 4,0%** e, per pura coincidenza aritmetica,
> **identico al cap C1 firmato**.
> 🟢 **E il misurato e' meta' dello strutturale**: la peggior giornata combinata
> mai vista nei dati e' **−2,38%** (1,00%) / **−1,55%** (0,65%).
> 👉 **Riparazione a costo zero e da proporre a Claudio: `InpMaxTradesPerDay=2`
> su `771531`** taglierebbe lo strutturale da 2,60% a 1,30% alla taglia 0,65%
> — 🔴 **ma tocca un parametro di rischio, quindi e' [FIRMA DI CLAUDIO] e va
> misurato prima** (quante posizioni delle 257 perderebbe? `2 o piu' segnali` in
> 26 giorni su 102).

## 6.4 🕳️ I PENDENTI, che il cap C1 non vede
Il cap **C1 = 3,25%** conta gli **SL vivi**, non i pendenti. Nel caso peggiore le
due sedie hanno insieme **1 pendente (770101) + 2 pendenti (771531)** =
**0,65% + 0,65% = 1,30% di rischio potenziale invisibile a C1**.
🟢 Che e' **dentro** il cap anche se lo si sommasse al rischio aperto:
**1,30% + 1,30% = 2,60% < 3,25%**. 🟢 E il caso patologico dell'oro (4 pendenti
= 3,94%) **non e' replicabile** da nessuna delle due: per codice non possono
averne piu' di 1 e 2.

---

# 7. 🧱 I MURI DELLA PROP, e il DD COMBINATO

**Il pacchetto firmato il 18/08** (`report/FIRME_2026-08-18.md`): pausa morbida
**−4,0%**, emergenza giornaliera **−4,9%**, emergenza totale **−9,9%**,
`InpDailyResetHour=23`. **Cap rischio aperto C1 = 3,25%: implementato e ACCESO
in tutti e due i preset del Guardian.**
🔴 **Tetto per cluster C2 = 3,0%: firmato il 07/09, IMPLEMENTATO
(`ABTG_Guardian.mq5` r.165 · r.471-472 · r.631 · r.877/896) ma NON ATTIVO, e va
detto ogni volta che si cita** — spento in **tre modi indipendenti**: default `0`
= no-op; **nessuno dei due preset lo valorizza**; e la versione **in campo** non
ha nemmeno la manopola (15 input contro 19). 👉 La frase giusta e'
*"va valorizzato e portato in campo"*, non *"va implementato"*.
**Finche' C2 e' spento, la decorrelazione si compra scegliendo il simbolo.**

## 7.1 Il portafoglio a due sedie, gradino per gradino e taglia per taglia

Motore: `backtest_pipeline/dd_portafoglio.py` (**strumento di casa**, non mio) +
la mia scala di stress. Monte Carlo: **20.000** rimescoli dei **giorni interi**
(conserva la correlazione dello **stesso giorno**, distrugge le **strisce**),
seed 42, deposito 100.000.

### 🔴 Taglia **1,00%** per sedia (la taglia del banco)

| gradino | DD storico | MC p50 | **MC p95** | **MC p99** | pegg. giornata comb. | contro i muri |
|---|---:|---:|---:|---:|---:|---|
| **base** | 4,34% | 6,07% | **9,90%** | 🔴 **12,17%** | −2,382% | 🔴 **p95 = 9,90% E' il muro d'emergenza; p99 SFONDA il 10%** |
| **+25%** | 4,70% | 6,28% | 🔴 **10,25%** | 🔴 **12,57%** | −2,403% | 🔴 **p95 sfonda 9,9% E 10%** |
| **+50%** | 5,18% | 6,51% | 🔴 **10,62%** | 🔴 **13,00%** | −2,424% | 🔴 |
| **+100%** | 6,16% | 7,00% | 🔴 **11,37%** | 🔴 **13,94%** | −2,467% | 🔴 |

### 🟢 Taglia **0,65%** per sedia (la taglia firmata)

| gradino | DD storico | MC p50 | **MC p95** | **MC p99** | pegg. giornata comb. | contro i muri |
|---|---:|---:|---:|---:|---:|---|
| **base** | 3,03% | 4,18% | 6,76% | **8,24%** | −1,548% | 🟢 dentro |
| **+25%** | 3,27% | 4,32% | 6,98% | **8,58%** | −1,562% | 🟢 |
| **+50%** | 3,60% | 4,48% | 7,24% | **8,85%** | −1,576% | 🟢 |
| **+100%** | 4,27% | 4,80% | 7,76% | 🟠 **9,40%** | −1,604% | 🟠 dentro, **0,50 punti** dal 9,9% |

Con la cella **REGALO** al posto della viva, il p99 a +100% sale a **9,59%**:
🟠 **0,31 punti dal muro** — la cella migliore ha un DD **piu' basso** da sola
(6,27% contro 7,23%) ma **piu' profitto**, e quindi un'equity piu' alta su cui
la coda del Monte Carlo pesca. **Va detto: sul DD combinato le due celle sono
alla pari, il regalo vince sul resto.**

> ## 🔴 **QUESTA E' LA NOTIZIA PIU' IMPORTANTE DEL COLLAUDO**
> **Alle due sedie insieme, alla taglia 1,00%, il DD combinato SFONDA il muro
> del 10% nello scenario p99 GIA' AL GRADINO BASE — e il p95 sfonda il 9,9%
> dal gradino +25%.** Alla taglia **0,65%** tengono **a ogni gradino**, con il
> p99 peggiore a **9,40%**.
> 👉 **Lo 0,65% non e' prudenza: e' la condizione di sopravvivenza del
> portafoglio a due sedie.** E il margine residuo al gradino piu' duro e'
> **mezzo punto**: non c'e' spazio per una **terza** sedia senza rimisurare.

⚠️ **[LIMITI del Monte Carlo, dichiarati]** rimescola i **giorni**: conserva la
correlazione dello stesso giorno, **distrugge le strisce**; il DD storico e'
**una** realizzazione, il p99 e' uno **scenario**, non una misura. E il campione
e' **21 mesi di un solo regime (toro)**: 🔴 **una notte di crollo che colpisce i
due indici insieme NON E' NEL CAMPIONE.** Il dato di casa che va accanto: su tre
indici una singola notte di crollo fa **22,74%**, e i portafogli larghi letti
hanno DD misurati del **32,6%** e **45,6%**. 👉 **Il numero del p99 non descrive
il crollo: descrive il rumore del toro.** Il crollo lo limita solo il Guardian,
e `770101` **e' piatta prima della notte** (`InpCloseHour=17:30`, **0/35
posizioni overnight**) mentre `771531` **dorme** (**4/21**, una attraverso un
weekend).

## 7.2 ✅ La verifica del criterio di RISCHIO firmato il 18/08 (DD forward vs DD promesso)

Il criterio si legge in **R** per non mescolare depositi:

| sedia | DD forward | in **R** | DD promesso dal banco | in **R** | verdetto |
|---|---:|---:|---:|---:|---|
| `770101` | 747,60 unita' (n=35, 20/07→11/09) | **6,50 R** | 7,2328% @1% | **7,23 R** | 🟠 **dentro, ma al 90% del promesso** |
| `771531` | 93,08 unita' (n=21, 14/08→04/09) | **4,62 R** di gamba | 7,8323% @1%, R di gamba = 0,5% | **15,66 R** | 🟢 **dentro con larghezza (29%)** |

🟠 **`770101` e' a 0,73 R dalla revisione immediata.** Il criterio **non
scatta** — ma su n=35 e con una sola striscia cattiva ci arriverebbe. **Va
scritto nel contratto della sedia e guardato ogni settimana.**

---

# 8. 🔴 IL RILIEVO CHE VA DAVANTI A TUTTO: le taglie in campo non tornano

Trovato mentre calibravo il valore del punto, e **non era la cosa che cercavo**.

Nella **finestra comune** (14/08 → 04/09/2026), sullo **stesso** conto demo
**`50503392`**, dallo stesso file (`data/statements/trades_auto.csv`):

| sedia | stop **pieno** | lotti | distanza | **rischio implicito** | contratto |
|---|---|---:|---:|---:|---|
| `770101` D30EUR | 14/08/2026 | 2,00 | 52,3 idx | **104,60** unita' | **0,65%** per posizione |
| `771531` U30USD | 04/09/2026 (gamba 1) | 0,20 | 117,0 idx | **20,15** unita' | **0,50%** per gamba |
| `771531` U30USD | 04/09/2026 (gamba 2) | 0,30 | 78,0 idx | **20,15** unita' | (segnale = **40,30**) |

```
rapporto MISURATO   770101 : 771531(segnale)  =  104,60 : 40,30  =  2,60
rapporto CONTRATTUALE                         =    0,65 :  1,00  =  0,65
                                                 discrepanza     =  4,0x
```

🔬 **Perche' questo numero e' solido: non dipende da nessuna mia calibrazione.**
La distanza e' `|open_price − close_price|` (misurata) e il rischio e' il `profit`
(misurato): **il valore del punto si elide nel rapporto.** Ed e' lo stesso
conto, nelle stesse settimane.

🔬 **Le spiegazioni alternative, provate e scartate:**
- *"e' l'arrotondamento del lotto"* → il `MathFloor` sul `lotStep` perde al
  massimo **25-33%** su un lotto da 0,2-0,3. **Non 4 volte.**
- *"sono conti diversi"* → no: entrambe su `50503392`, `chart30.chr` e
  `chart33.chr` nel censimento del 12/09.
- *"e' un'uscita in trailing, non uno stop pieno"* → ho preso solo il **massimo**
  del grappolo di perdite di ciascuna (la firma dello stop pieno); le perdite
  minori (es. −14,04 con 0,6 lotti su 23,4 idx) sono **stop spostati**, e le ho
  escluse.

👉 **L'ipotesi piu' economica, e va verificata e non creduta:** in campo
`770101` porta gli input **legacy** invece del preset del 100k. In repo esiste
`mql5/Presets/ABTG_DAX_Apertura_EU_LEGACY_2pct.set`, e un rischio del **2%**
darebbe esattamente un rapporto di **~4x** contro lo 0,5% di gamba della
gemella. 🔴 **Se questa sedia arrivasse sul conto di una prop con il 2%, il DD
promesso di 7,23% diventerebbe ~22% e il muro del 10% morirebbe alla prima
striscia.** Sarebbe il modo piu' stupido di perdere una challenge misurata bene.

## 🙋 LA COSA CHE CHIEDO A CLAUDIO — costa trenta secondi e vale la challenge

🪟 **Terminale bersaglio: `50503392`** — `C:\Program Files\BCM Markets MT5 Terminal`
(**demo piccolo**). 🛑 **Non si tocca** ne' `50504263` (100k), ne' `10105439`
(reale), ne' `50504400` (backtest), ne' le cartelle Pepperstone/Tickmill.
✋ **Azione a mano dentro MT5, sola lettura**: sul grafico **`D30EUR`** con
`ABTG_DAX_Apertura_EU` → tasto destro → *Lista degli Expert* / proprieta' →
scheda **Parametri in ingresso** → **una foto** di `InpRiskPercent`,
`InpMagic`, `InpAllowReverse`, `InpTP1_ClosePct`, `InpCloseHour`.
E per riconoscere la finestra **senza indovinare**, prima questa riga di sola
lettura — 🖥️ **finestra PowerShell sul VPS** (non apre e non tocca nessun MT5):

```
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

Stessa foto per il grafico **`U30USD`** con `ABTG_EMA200` (`InpRiskPercent`,
`InpUseOrder2`, `InpMaxTradesPerDay`). 👉 **Due foto e la discrepanza di §8 si
chiude o si conferma.** Non posso chiuderla io: in repo ci sono i preset, in
campo c'e' quello che e' stato trascinato sul grafico.

---

# 9. 🧰 LE MISURE NUOVE: i file prova, pronti e gatati

## 9.1 Quello che ho scritto io

| file | cosa misura | celle | passate | round | **T (min)** |
|---|---|---:|---:|---:|---:|
| `backtest_pipeline/prove/COLLAUDO_DAX101_CRITERI.md` | 🧊 **i criteri congelati** (nessuna passata) | — | 0 | 0 | 0 |
| `backtest_pipeline/prove/COLLAUDO_DAX101_01_spread_scala_ini.txt` | 🚦 canarino `-Spread 0` vs `99999` | 2 | 4 | 2 | **1,51** |
| ↳ lo stesso file, i quattro gradini | 🛡️ scala **base/+25%/+50%/+100%**, **due celle** (viva e regalo) | 2 | 16 | 4 | **3,63** |
| | **TOTALE** | | **20** | **6** | **5,14** |

Metro di casa: **`T = 0,6 + 0,077 x passate`, per ROUND** (ogni `-Spread` e' un
round separato: lo spread lo scrive il **driver**, non il file prova).

**Dentro il file, scritte PRIMA dei numeri:**
- 🚦 **il canarino viene prima e puo' uccidere la prova**: non e' misurato che MT5
  onori `Spread=` a Modello 4 (lo dice il driver stesso, `walkforward_generico.ps1`
  r.950-955). **K1 == K2 ⇒ «NON MISURABILE», mai «robusta allo spread».**
- 📐 **l'attesa aritmetica al centesimo** (i dodici numeri di §4.1 e §4.2);
- 🔔 **la sentinella che distingue costo da selezione**: *se `Trades` cambia piu'
  del 5% fra un gradino e la base, il gradino misura la **SELEZIONE** e non il
  **COSTO**, e va dichiarato cosi' prima di qualunque verdetto*;
- 📌 `InpSessionHour=8` = **ORA SERVER BCM** (09:00 italiane). Un CSV con **9** si
  cestina;
- 📌 `InpMagic=787101`, **vergine** (verificato repo-wide: `grep -rE "\b7871[0-9][0-9]\b" --exclude-dir=.git .` → **0**);
- 📌 nessun `@FINOA`, **di proposito**: serve al canarino per passare
  `-DaQuando/-Fino`. R47 stesso non lo dichiarava e prese il default `2026.06.30`;
- 📌 `InpNewsCurrencies` **non pinnato** (un pin di stringa vuota MT5 lo **ignora**).

## 9.2 🚦 I cancelli, riprodotti qui

**Esito 1 — byte non-ASCII** (contati con **python3**, **NON** con
`grep '[^\x00-\x7F]'` che e' rotta): `COLLAUDO_DAX101_01_spread_scala_ini.txt`
⇒ **zero**.

**Esito 2 — `controlla_prova.py`** (cancello semantico dei file prova), riprodotto:

| file | EA riconosciuto | pin | celle | esito |
|---|---|---:|---:|---|
| `COLLAUDO_DAX101_01_spread_scala_ini.txt` | `ABTG_DAX_Apertura_EU.mq5` | **81** | **2** | **OK** |

`file: 1 | celle totali: 2 | passate (celle x 2 finestre): 4 | problemi: 0` ·
**ESITO: OK**, codice d'uscita **0**.

**Esito 3 — `controlla_riga.py --oggetto prova`**: *"OK file prova ASCII puro"* ·
*"ESITO: nessun difetto meccanico"*, codice d'uscita **0**.

🔴 **Classe 273, verificata a mano perche' i cancelli non la vedono:**
`-Modello 4` = **tick reali**, `-Modello 1` = **OHLC M1**; nel file il **modello
non e' pinnato** (arriva dalla riga di lancio, dove il default del driver e'
**4**, `walkforward_generico.ps1` r.180) e **nessun commento e' invertito**.
🔴 **Il secondo strato del cancello — l'agente `controllo-preventivo` — lo lancia
il coordinatore. Lo dichiaro e non lo do per fatto.** Fino al suo PASS, niente
verso il VPS.

## 9.3 🔧 Le due misure che NON costano passate, e una e' urgente

**(a) 🥇 Portare in `ABTG_EMA200.mq5` il blocco che misura la peggior giornata di
EQUITY.** Esiste **gia'** in `ABTG_DAX_Apertura_EU.mq5` e funziona: r.382-384
(tre variabili), r.616-623 (otto righe dentro `OnTick`), r.2283 (una riga di
`stats[]`), r.2338 (l'intestazione del CSV). 👉 **Chiude un `[NON MISURABILE]`
che DUE referti dichiarano irrisolvibile**, e viaggia sul primo round che gira:
**ZERO passate**.
🛑 **NON l'ho applicata, e non va applicata oggi**: il driver compila dall'HEAD
di `lavoro` e in coda ci sono round che girano stanotte — toccare l'EA
romperebbe il loro cancello di determinismo. **E' una proposta.**

**(b) Lo spread orario dei simboli mancanti**, con `ABTG_SpreadOrario`: **zero
passate di tester**. `spread_flotta/` ha **3 file su 13 simboli**. Serve se si
allarga la famiglia a `F40EUR` (proposta `R138a` del dossier di stamattina).

## 9.4 🔴 Una correzione al pacchetto di collaudo che esisteva gia'

`prove/COLLAUDO_EMADOW_01_spread_scala_ini.txt` (non e' mio, **non l'ho
toccato**) usa una base di **1,9 idx**, giustificata come *"mediana delle ore
14-21, dove cade il 55,7% delle uscite"*. 🔴 **Ma il restante 44,3% cade dove lo
spread e' 2,6-2,8**, e la sedia gira 24 ore. Pesando le **257 posizioni** sulle
ore vere: **2,221 idx** (ore di chiusura) e **2,440 idx** (ingresso ≈ chiusura −4h,
durata mediana misurata 2,50-3,70 h).
👉 **I gradini 238/285/380 sottostimano la base del 17-28%.** Proposta: base
**2,44 idx** ⇒ `-Spread` **244 / 305 / 366 / 488**, e ri-passaggio dai cancelli.
🟢 **Quel file resta buono in tutto il resto**, e il suo conto aritmetico
coincide col mio alla prima cifra (§5.2).

---

# 10. 🕳️ COSA QUESTO COLLAUDO **NON** COPRE — elencato per nome (classe 180)

| # | cosa | perche' | conseguenza |
|---:|---|---|---|
| 1 | **requote e rifiuti d'ordine** | nessuna fonte in casa li contiene | 🔴 **nessun gradino li modella**, su nessuna delle due sedie |
| 2 | **l'esecuzione della PROP VERA** | si collauda contro il feed e i costi **BCM** | il profilo commissioni della prop e' `[NON MISURATO]` |
| 3 | **il cambio di SELEZIONE a spread largo** | i due ingressi sono **LIMIT**: con l'ask piu' alto si innescano in giorni diversi | lo misura **solo** la scala a tick reali (§9.1), e c'e' la sentinella sul conteggio `Trades` |
| 4 | **lo spread al MINUTO dentro l'ora** | l'istogramma e' **orario**, e per `770101` l'ora 08 e' **l'apertura europea** | 🔴 **tutti i rapporti stop/spread di `770101` sono OTTIMISTI PER COSTRUZIONE** |
| 5 | **la PROVA DI REGIME** | 21 mesi di storico BCM sugli indici, stato `COMPLETO`: **un solo toro** | la regola C dell'Emendamento **non e' soddisfatta e non lo sara' il 30/09**. Il p99 del Monte Carlo descrive il **rumore del toro**, non un crollo |
| 6 | **la peggior escursione giornaliera di EQUITY di `771531`** | `ABTG_EMA200.mq5` non ha il blocco che ce l'ha il DAX | resta un **pavimento sui chiusi** (−2,4484%). Si chiude con §9.3(a), **zero passate** |
| 7 | **lo swap di `U30USD` su un broker diverso** | misurato **0,00** su BCM (4 posizioni overnight di 21) | 🔴 `771531` **dorme**: su una prop che addebita, e' un costo nuovo. `770101` no (**0/35** overnight, `InpCloseHour=17:30`) |
| 8 | **il filtro notizie** | `InpUseNewsFilter=false` su **entrambe** | `770101` tiene posizione fino alle 17:30 server: i dati USA delle 14:30 cadono **dentro** la sua finestra. Non modellato |
| 9 | **la taglia vera in campo** | vedi §8: discrepanza **4,0x** non spiegata | 🔴 **e' un presupposto MANCANTE, non un dettaglio**: tutti i numeri di §7 assumono le taglie di contratto |
| 10 | **il DD combinato con una TERZA sedia** | fuori perimetro | al gradino +100% il margine sul 9,9% e' **mezzo punto**: una terza sedia va **rimisurata**, non aggiunta |

---

# 11. 🏁 IL VERDETTO — schierabili il 1 ottobre, SI o NO

## 🪑 `770101` `ABTG_DAX_Apertura_EU` D30EUR M5 LONG

> ## ✅ **SI — con la manopola `InpTP1_ClosePct` a 0 e alla taglia 0,65%. Con la manopola a 50 il verdetto e' 🟠 PASS FRAGILE.**

| criterio congelato | cella **VIVA** (50) | cella **REGALO** (0) |
|---|---|---|
| **S1 PASS a +50%**: profitto>0 · PF≥1,10 · DD eq ≤8,0% · pegg. giorn ≥−2,50% · n≥150 | ✅ ✅ ✅ ✅ ✅ → **PASS** | ✅ ✅ ✅ ✅ ✅ → **PASS** |
| sopravvivenza a **+100%** | 🟢 PF 1,266 · DD 8,11% | 🟢 PF 1,360 · DD 7,03% |
| **latenza 5 idx** | 🔴 **PF 1,0353 — sotto 1,10** | 🟢 **PF 1,1281** |
| **margine prima di PF 1,10** | 4,02 idx (**2,37x** la base) | **5,43 idx (3,20x)** — **+35%** |
| **frontiera a +100%** | 16,5x mediana, 🔴 **19,7% sotto il duro** | identica (stesse 193 posizioni) |
| **S6 il regalo** | — | ✅ **batte la viva a TUTTI E QUATTRO i gradini** su PF, DD e peggior giornata |

**Cosa manca, per nome:** (1) 🔴 **la foto del pannello input** per chiudere la
discrepanza di taglia di §8 — **e questa e' bloccante**; (2) la **firma** su
`InpTP1_ClosePct` 50 → 0, che ha ora **quattro** letture indipendenti a favore
(09/09, 12/09 ×2, e questo collaudo sotto stress); (3) la scala a **tick reali**
di §9.1 (5,14 min) per chiudere il gradino con una misura invece di
un'aritmetica; (4) ⚪ **la prova di regime, che non si chiude entro il 30/09.**

## 🚄 `771531` `ABTG_EMA200` U30USD H1 **L+S** (non "LONG")

> ## ✅ **SI — alla taglia 0,65%. Alla taglia 1,00% e' 🟠 FRAGILE sul DD (8,18% contro una soglia di 8,0% a +50%).**

**Cosa manca, per nome:** (1) 🔴 il **preset del 100k (`881531`) NON ESISTE**;
(2) 🟠 la **peggior escursione giornaliera di EQUITY** — `[NON MISURATA]`, e si
chiude con **8 righe e zero passate** (§9.3a); (3) 🔴 **l'ora 23**, dove al p95
il **30,4%** delle posizioni sta sotto il pavimento duro, e `InpMaxSpread=0`
non la ferma; (4) 🟠 il **limite strutturale della giornata** (§6.3), che con
`InpMaxTradesPerDay=0` arriva a 2,60% da sola; (5) l'**`n` dell'IS in posizioni**
e la **gestione dell'uscita** (`R136a/b/c/d` di stanotte).

## 🔴 E LE TRE CONDIZIONI DEL PORTAFOGLIO, che valgono piu' delle due sedie singole

1. 🔴 **LA TAGLIA E' 0,65%, E NON E' UNA PREFERENZA.** Alla taglia **1,00%** il
   DD combinato **sfonda il muro del 10%** nello scenario p99 **gia' al gradino
   base** (12,17%) e il p95 sfonda il 9,9% **dal +25%** (10,25%). Alla taglia
   **0,65%** tengono a ogni gradino (p99 peggiore **9,40%**).
   👉 `[FIRMA DI CLAUDIO]`, e io la propongo col numero.
2. 🔴 **LA DISCREPANZA DI §8 SI CHIUDE PRIMA DELLA PARTENZA.** Tutti i numeri di
   §7 assumono le taglie **di contratto**. Se in campo `770101` gira al 2%, il
   portafoglio a due sfonda il 10% **anche alla taglia nominale 0,65%** della
   gemella, e lo sfonda nel primo mese. **Due foto.**
3. 🟠 **NON C'E' SPAZIO PER UNA TERZA SEDIA senza rimisurare.** Al gradino +100%
   il margine sul muro d'emergenza e' **mezzo punto** (9,40% contro 9,9%). E il
   **tetto per cluster C2** — che e' esattamente la protezione che servirebbe
   per una terza sedia su un indice — e' **firmato, implementato, e SPENTO in
   tre modi**.

## 🟢 E COSA E' ANDATO BENE, perche' un elenco di difetti senza le vittorie descrive male la realta'

- 🟢 **Le due sedie reggono lo spread raddoppiato.** Era la domanda del collaudo,
  e la risposta e' **si'**, con i numeri.
- 🟢 **La correlazione fra le due e' MISURATA ~zero, su due letture indipendenti**
  (−0,0045 e +0,0083), e il beneficio di diversificazione e' **+9,45 punti** di DD.
- 🟢 **I due motori si rompono in modi DIVERSI** (uno di PF, uno di DD): e' la
  proprieta' che si vuole in un portafoglio, ed e' misurata, non sperata.
- 🟢 **Il regalo e' MIGLIORE, e ora anche PIU' ROBUSTO**, con il contro-esempio
  costruito e caduto: paga **piu'** pedaggio e vince **lo stesso**, a ogni gradino.
- 🟢 **Due `[NON MISURABILE]` sono diventati numeri senza lanciare niente**: la
  peggior giornata di **equity** di `770101` (**−1,0780%**, e uno dei due
  referti la dava per non misurabile) e il **massimo di posizioni
  contemporanee** di `770101` (**1**, da codice **e** da 193 giorni di dati).
- 🟢 **Commissione e swap: 0,00 MISURATI** su 237 posizioni di indici, non
  assunti. Il pedaggio all-in di queste due sedie **e' lo spread e nient'altro**.
- 🟢 **Cinque numeri scritti da altri riprodotti al decimale**, e uno al **quarto
  decimale contro una misura fatta dentro l'EA a ogni tick**.

---

# 12. 📚 FONTI — tutte sul branch `lavoro`, tutte aperte e ricontate

**Per-trade e riepiloghi (rango 1, MISURATO):**
`backtest_pipeline/risultati_prove/aperture_r47/` (4 riepiloghi + 4 per-trade) ·
`backtest_pipeline/risultati_archivio/R112_CORSA_20260826/` (riepiloghi + `pertrade_00_metro_763400.csv`) ·
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` (30.974.789 tick) e `spread_orario_U30USD.csv` (64.711.285 tick) ·
`data/statements/trades_auto.csv` (1.303 righe; `open_time`, `commission`, `swap`, `close_reason`)

**Sorgenti letti riga per riga:**
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.257-258, r.313-314, r.344-346, r.359, r.382-384, r.587, r.595-602, r.616-623, r.628-660, r.1481-1545, r.1791-1826, r.2283, r.2338 ·
`mql5/Experts/ABTG_EMA200.mq5` r.318-325, r.352-368 ·
`mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` ·
`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set` ·
`backtest_pipeline/walkforward_generico.ps1` r.177-193, r.942-960 (**sola lettura**)

**Strumenti di casa usati, non scritti da me:**
`backtest_pipeline/dd_portafoglio.py` · `backtest_pipeline/controlla_prova.py` ·
`backtest_pipeline/controlla_riga.py` · (citati e non usati, col motivo:
`misura_slippage.py` vuole i report `.htm`, che non ho;
`calcola_pedaggio_forex.py` e' scritto per le **coppie** e sugli indici la
commissione misurata e' **zero**)

**Referti di riferimento:** `report/LA_SECONDA_SEDIA_2026-09-12.md` ·
`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` · `report/FIRME_2026-08-18.md` ·
`report/FIRME_2026-09-07.md` · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` ·
`report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md` ·
`backtest_pipeline/prove/COLLAUDO_EMADOW_01_spread_scala_ini.txt` (non toccato)

> **Se un referto e questo collaudo divergono, comanda il referto** — tranne sui
> numeri che questo collaudo **ricalcola dai file grezzi e dichiara come
> correzione**: il lato **L+S** di `771531` (§4.3), la base di spread
> **2,22-2,44 idx** al posto di 1,9 (§9.4), e la peggior giornata di **equity**
> di `770101` che **non e'** `[NON MISURABILE]` (§2.2).

---

_🛑 **Zero modifiche al forward. Nessun EA, preset, parametro, magic o grafico
toccato. Nessun backtest lanciato. `backtest_pipeline/coda/CODA.txt` non aperto
in scrittura. Nessuna promozione, nessuna accensione, nessuna spesa.** Taglie e
parametri di rischio sono di Claudio; lo schieramento e' una sua decisione._
