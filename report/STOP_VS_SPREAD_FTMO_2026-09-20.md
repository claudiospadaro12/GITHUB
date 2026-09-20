# 🎯 LO STOP CONTRO LO SPREAD FTMO — le cinque sedie, misurate

**20/09/2026, sera.** Misura in **SOLA LETTURA** su quello che c'è già in repo.
🛑 **Nessun preset toccato, nessun EA toccato, nessuna taglia, nessun magic, nessun
backtest lanciato.** `InpMinStopPts`, `InpSkipIfTight` e `InpMaxSpread` qui si
**PROPONGONO**, non si scrivono. Il conto reale `10105439` non è stato nemmeno nominato in
una riga di comando.

---

# 0. 🥇 IL VERDETTO IN TRE RIGHE

1. ✅ **`770202` Dow e `770260` Nasdaq si accendono stasera senza toccare niente**:
   **47,1×** e **54,4×** contro il pavimento di lavoro 40×, con **+17,7%** e **+35,9%**
   di margine sullo spread FTMO misurato.
2. 🟡 **`770101` DAX si accende, e sullo spread FTMO STA MEGLIO che su BCM**: il pedaggio
   scende del **15,9%** (GER40 1,43 contro D30EUR 1,70 all'ora d'ingresso). Resta al filo
   — **38,4×** sulla geometria viva `[MISURATO, n=3]` — ma accenderla **non peggiora**
   niente rispetto a dove gira oggi (33,0× su BCM).
3. 🔴 **`771531` EMA200 e `770511` SuperWave sono le uniche due che PEGGIORANO passando a
   FTMO**, e sono le uniche due **sotto il pavimento di lavoro**: **39,7×** (era 54,9× su
   BCM) e **29,3×** (era 38,5×). Il pedaggio sul Dow sale del **+38,4%** e **+31,5%**.
   **Non è uno spegnimento** (la regola R5 dice *raccomandazione*, e il pavimento **duro**
   13,3× regge su tutte e cinque): è una **firma di Claudio** presa sapendo il numero.

> 🔴 **E LA RIGA CHE VA LETTA PRIMA DI TUTTE**: la frontiera 57,2 / 105,2 / 61,2 poggia su
> **UN SOLO TICK di spread**, letto alle **17:08 = ora 16 server BCM**, che è l'ora **più
> calma** della giornata. **Tre delle cinque sedie entrano all'apertura cash**, dove sui
> tick BCM il massimo su `U30USD` è **47,0 punti indice**. Lo spread FTMO **all'apertura è
> `[NON MISURATO]`**. §7 dice come misurarlo in dieci minuti.

## 🔧 E LA MANOPOLA — la frontiera **è già dentro l'EA**, e va lasciata com'è stasera

`InpMinStopPts` + `InpSkipIfTight` (§6) **sono** il cancello del costo, per-trade, col log
che lo dice. Oggi: **no-op su `770101`** (floor a 0 ⇒ il `SkipIfTight=true` non si attiva
mai) e **a 5,00 punti indice su `770202`/`770260`**, cioè 21× e 12× sotto la frontiera.

🎯 **La curva, misurata su 440-447 giornate vere** (non stimata), portando il floor a 40×:

| sedia | operazioni superstiti | DD del proxy | PF del proxy |
|---|---:|---:|---:|
| `770101` | 🔴 **73,9%** (−26,1%) | 🟢 46,1 → **21,1 R** (−54%) | 1,042 → **1,080** |
| `770202` | 🟡 **72,6%** *(0% perse se resta `SkipIfTight=false`: allarga lo stop)* | 🟢 16,7 → **10,4 R** | 1,134 → **1,166** |
| `770260` | 🟡 **79,0%** | 36,8 → 32,8 R | 🔴 1,001 → **0,980 — PEGGIORA** |

> ## ✍️ **PROPOSTA: STASERA NON SI TOCCA NIENTE.**
> Alzare il floor è **cambiare cella**, e una cella con floor a 40× **non è mai girata a
> tick reali**. Il numero che ho è un **proxy** (breakout cieco, PF 1,00-1,17: **non è la
> cella**). Accendere sulla challenge pagata una configurazione mai validata, per
> rispettare un pavimento di **lavoro**, sarebbe peggio del problema che risolve.
> 👉 Il floor si alza **dopo** la corsa `R152a` già scritta in repo (§7.5 P4).

---

# 1. 🔴 LA PRIMA CORREZIONE, PRIMA DEI NUMERI: **NON HANNO LO STOP AD ATR**

Il brief dice: *«le cinque hanno tutte stop ad ATR (quindi NON calcolabili dal preset)»*.
**È falso per tre delle cinque, ed è la stessa trappola della CLASSE 495 di stamattina.**

```mql5
// mql5/Experts/ABTG_DAX_Apertura_EU.mq5  r.236-237
   ABTG_SL_RANGE = 0,   // stop sull'estremo opposto del range
   ABTG_SL_ATR   = 1    // stop a X volte l'ATR
```

| sedia | preset FTMO | che cosa vuol dire DAVVERO |
|---|---|---|
| `770101` · `770202` · `770260` | `InpSLMode=0` | 🔴 **`ABTG_SL_RANGE`** — stop sul **bordo opposto del range d'apertura**. `InpAtrSlMult=1.5` e `InpAtrPeriodMgmt=14` sono **manopole INERTI** |
| `771531` | `InpSLatr=1.0` | ✅ davvero ATR(14) H1 |
| `770511` | `InpSLLookback=5` + `InpSLBufferPips=3.0` | ✅ swing di 5 barre H1 (e il buffer «3 pip» vale **0,03 punti indice**: inerte) |

🟢 **E questo CAPOVOLGE la conclusione «non calcolabili dal preset»: su tre sedie su
cinque lo stop è una GEOMETRIA ESATTA**, letta nel ramo RETEST del sorgente
(`ABTG_Nasdaq_Apertura_US.mq5` r.1547-1551 · `ABTG_Dow_Apertura_US.mq5` r.1320 ·
`ABTG_DAX_Apertura_EU.mq5` r.1488-1491):

```
entry = rangeHigh - InpRetestOffsetPts        sl = rangeLow - InpBufferPoints
  =>  DISTANZA DI STOP = larghezza del range d'apertura + (buffer - offset)
```

| sedia | buffer | offset retest | **stop = larghezza range +** |
|---|---:|---:|---:|
| `770101` GER40 | 500 pt = 5,00 idx | 200 pt = 2,00 idx | **+3,00** |
| `770202` US30 | 1000 pt = 10,00 idx | 400 pt = 4,00 idx | **+6,00** |
| `770260` US100 | 200 pt = 2,00 idx | 0 | **+2,00** |

👉 **Quindi la distribuzione dello stop di quelle tre è la distribuzione della LARGHEZZA
DEL RANGE D'APERTURA** — e quella in casa è **già misurata su 440-447 giornate**.

📌 *Stessa famiglia della correzione di stamattina su `770411`: il brief lo dà per «stop
fisso 3000 punti = 30,0 idx, 21×». La **CLASSE 495** della checklist (20/09) lo ha già
smontato: `InpSLMode=1` è `MM_SL_ATR`, `FIXED` è `2`, e lo stop vero è `ATR(14) M15 × 2,5`.
Il 21× non esiste.*

---

# 2. ⚖️ LE UNITÀ: **BCM E FTMO PARLANO LA STESSA LINGUA** — verificato, non assunto

Il brief chiede di non dare per scontato che «punto» voglia dire la stessa cosa.
**Verificato su due sonde indipendenti, e la risposta è: stessa lingua.**

| | **Digits** | **Point** | **TickSize** | **ContractSize** | **TickValue** | **EUR / punto indice / lotto** |
|---|---:|---:|---:|---:|---:|---:|
| BCM `D30EUR` | 2 | 0,01 | 0,10 | 10 | 0,10 | 🟢 **1,00000** `[MIS, n=154 trade veri]` |
| FTMO `GER40.cash` | 2 | 0,01 | 0,01 | 1 | 0,01000 | 🟢 **1,000** |
| BCM `U30USD` | 2 | 0,01 | 0,10 | 10 | 0,10 | **0,86091** `[MIS, n=62]` |
| FTMO `US30.cash` | 2 | 0,01 | 0,01 | 1 | 0,00871 | **0,871** (+1,2%) |
| BCM `NASUSD` | 2 | 0,01 | 0,10 | 10 | 0,10 | **0,86680** `[MIS, n=59]` |
| FTMO `US100.cash` | 2 | 0,01 | 0,01 | 1 | 0,00871 | **0,871** (+0,5%) |

**Fonti**: FTMO = `backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`
sezione `[SIMBOLI]` · BCM = `backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`
(sonda `ABTG_InfoBroker`, conto 50503392, 17/08) **+** `data/spread_vivo/SPREAD_VIVO_2026-09-12_istogramma.csv`
righe `SYM` (`SYM,D30EUR,2,0.01000000,100.0,vivo`) **+** il valore per punto **ricalcolato
dai trade veri** (`profit / (Δprezzo × volume)`) su `data/statements/trades_auto.csv`.

> ## 🟢 **`Digits = 2` e `Point = 0,01` su tutti e sei. 1 punto indice = 100 punti MT5 su tutti e sei.**
> 👉 **Nessun riscalamento. Le distanze di stop in punti indice e gli spread in punti MT5
> si confrontano direttamente fra i due broker.** Il «fattore 10» di `ContractSize` e
> `TickSize` **si semplifica** (0,10/0,10 = 0,01/0,01 = 1): non tocca né il pedaggio né il
> valore per punto.
> ⚠️ **L'unica differenza reale è il valore per punto sui due indici USA: +1,2% e +0,5%.**
> Il lotto lo calcola `CalcLotByRisk` da `SYMBOL_TRADE_TICK_VALUE`, quindi **si corregge da
> solo**: il rischio in EUR resta quello dichiarato. Nessun conto qui dentro va riscalato.

🔴 **Un rilievo che va scritto**: la sonda `ABTG_InfoBroker` stampa per `U30USD`/`NASUSD`
`TickValue/TickSize = 0,10/0,10 = 1,00 EUR/punto`, ma **62 e 59 trade veri dicono 0,861 e
0,867**. Chi prendesse quel `1,00` dalla sonda sbaglierebbe il lotto del **16%**. In questo
referto ho usato il numero **misurato dai trade**, non quello della sonda.

---

# 3. 📏 LA DISTANZA DI STOP, SEDIA PER SEDIA

## 3.1 🔬 IL METODO, e il lucchetto che lo rende valido

Dalla lista trade vera: **una posizione chiusa `close_reason = sl` e IN PERDITA
geometrica porta ANCORA lo stop iniziale**, perché il trailing non può entrare nella zona
di perdita:

| EA | il lucchetto | esito |
|---|---|---|
| `ABTG_DAX_Apertura_EU` r.1986/1992 · `ABTG_Dow_Apertura_US` r.1817/1823 · `ABTG_Nasdaq_Apertura_US` r.2230/2236 | `newSL > sl && newSL > openP` | 🟢 **chiuso** |
| `ABTG_EMA200` r.436 | trailing **solo** `if(... && beDone ...)`, e `beDone ⇔ sl ≥ openP` | 🟢 **chiuso** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` r.468-471 | 🔴 il trailing su Supertrend **NON è dietro `beDone`**: `if(haveST){ if(stLine>slNow && stLine<bid) ... }` | 🔴 **APERTO** — vedi §3.4 |

Distanza = `|prezzo di apertura − prezzo di chiusura|` in punti indice.
Fonti: `data/statements/trades_auto.csv` (piccolo **50503392**) e
`data/statements/trades_100k.csv` (**50504263**).

## 3.2 ✅ `770101` DAX Apertura — `GER40.cash`, frontiera **57,2**

| # | data | conto | modo | **stop (punti indice)** |
|---:|---|---|---|---:|
| 1 | 14/08 | piccolo | ROTTURA | **52,30** |
| 2 | 14/08 | 100k | **RETEST** | **54,90** |
| 3 | 10/08 | piccolo | ROTTURA | **59,90** |
| 4-5 | 29/07 | piccolo | ROTTURA | **71,90** · **71,90** |
| 6 | 29/07 | piccolo | ROTTURA | **75,50** |
| 7 | 06/08 | piccolo | ROTTURA | **114,40** |
| 8 | 23/07 | piccolo | ROTTURA | **127,00** |

> **n = 8** · **minimo 52,30** · **P10 54,12** · **MEDIANA 71,90** · max 127,00
> 🔴 **SOTTO LA FRONTIERA 57,2: 2 su 8 = 25,0%**
> mediana **50,3×** · P10 **37,8×** · minimo **36,6×**

🎯 **E il sottocampione che conta davvero**: la geometria **viva** (RETEST 35'/500) è in
produzione **dalle 19:25 del 06/08** (`report/giornata_2026-08-06.md` r.93-95). Le gambe
successive sono **tre**: 52,30 · 54,90 · 59,90 → **mediana 54,90 = 38,4×** `[MISURATO, n=3]`.
*(il referto `CANCELLO_COSTO_FLOTTA` usa n=2 perché guarda solo il piccolo: mediana 56,10)*

## 3.3 ✅ `771531` EMA200 Dow — `US30.cash`, frontiera **105,2**

| data | gamba | **stop** | | data | gamba | **stop** |
|---|---|---:|---|---|---|---:|
| 24/08 | S2 | **65,50** | | 27/08 | L1 | **110,40** |
| 27/08 | L2 | **73,60** | | 04/09 | L1 | **117,00** |
| 04/09 | L2 | **78,00** | | 28/08 | L1 | **142,90** |
| 24/08 | S1 | **98,20** | | 24/08 | S1 | **147,00** |

> **n = 8** · **minimo 65,50** · **P10 71,17** · **MEDIANA 104,30** · max 147,00
> 🔴 **SOTTO LA FRONTIERA 105,2: 4 su 8 = 50,0%**
> mediana **39,7×** · P10 **27,1×** · minimo **24,9×**
> *(la mediana 104,30 riproduce al centesimo quella di `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.406)*

## 3.4 🔴 `770511` SuperWave Dow — `US30.cash`, frontiera **105,2**

Qui ho **due** strade, e la seconda è quella che toglie il bias.

**A) gambe chiuse in stop** (limite **INFERIORE**: il trailing su Supertrend può aver già
stretto lo stop — §3.1):

| data | gamba | **stop** |
|---|---|---:|
| 27/07 | STRev L 1/3 | **12,70** |
| 31/07 | L 1/3 | **55,70** |
| 03/09 | L 1/3 | **98,50** |
| 03/09 | L 2/3 | **98,70** |

**B) ricostruito dal TAKE PROFIT** — `tp = entry ± risk × InpTP_RR` con `InpTP_RR=3.0`
(`ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.377) ⇒ `risk = |tp − entry| / 3`. 🟢 **Questo è
lo stop INIZIALE ESATTO, e viene da operazioni VINCENTI**, cioè da giornate che il gruppo A
non può vedere:

| data | gamba | **stop ricostruito** |
|---|---|---:|
| 29/07 | S 1/3 · S 2/3 | **55,00** · **55,00** |
| 31/08 | S 1/3 · S 2/3 | **171,30** · **171,30** |
| 07/09 | S 1/3 · S 2/3 | **171,50** · **171,50** |

> **A+B: n = 10 gambe (6 segnali)** · **minimo 12,70** · **P10 50,77** · **MEDIANA 98,60**
> 🔴 **SOTTO LA FRONTIERA 105,2: 6 su 10 = 60,0%**
> mediana **37,5×** · P10 **19,3×** · minimo **4,8×**
> *(con la sola mediana di casa, 77,10 su n=4: **29,3×**)*

🔴 **Il minimo a 12,70 punti indice vale 4,8× lo spread FTMO. È sotto il pavimento DURO
(13,3×)**: quell'operazione, su FTMO, sarebbe nata già dentro il costo.

## 3.5 ⚪ `770202` e `770260` — **ZERO gambe in stop in forward**, e allora si ricostruisce

| sedia | operazioni in archivio | gambe chiuse in stop **in perdita** |
|---|---:|---:|
| `770202` Dow Apertura | 7 (4 piccolo + 3 100k) | 🔴 **0** — le 6 uscite `sl` sono tutte **VINCENTI** (trailing) |
| `770260` Nasdaq RETEST | 🔴 **0** — magic mai girato in campo | — |
| *(famiglia Nasdaq Apertura `770201`/`770250`/`770211`)* | 15 | **1** (115,50, ma è `770211` = EA *Ottimizzato*, altra geometria) |

> ## 🔴 **Dalle operazioni forward, `770202` e `770260` sono `[NON MISURATO]`. Punto.**

**Ma non ci si ferma qui** (motto del 09/09: *se manca il NUMERO, si trova la via più corta
al numero*). Il §1 ha dimostrato che il loro stop **è** la larghezza del range d'apertura +
una costante nota, e quella larghezza in casa **è misurata su 440-447 giornate BCM**:
`backtest_pipeline/risultati_archivio/studio_apertura/Studio_{D30EUR,U30USD,NASUSD}.csv`,
colonna `ampiezza_pt` (= `(gHi−gLo)/_Point`, `ABTG_Apertura_Study_EA.mq5` r.210), apertura
**08:00** per il DAX e **14:30** per i due USA — **le ore giuste**.

⚠️ **Limite dichiarato, e tira nella direzione PRUDENTE**: lo Studio usa un range di
**15 minuti**, le celle vive girano a **`InpRangeMinutes=35`**. Il range di 35' è **più
largo**, quindi la ricostruzione a 15' è un **limite INFERIORE** dello stop e un **limite
SUPERIORE** della quota sotto frontiera. Do tutte e due le letture: **A** a 15' `[MISURATO]`
e **B** scalata con `√(35/15) = 1,528` `[INFERITO, legge di casa `ANCORA_ADR_FLOTTA_INDICI`]`.

| sedia | lettura | min | **P10** | **MEDIANA** | **sotto frontiera** | mediana/spr | P10/spr |
|---|---|---:|---:|---:|---:|---:|---:|
| **`770101`** GER40 (57,2) | A 15' `[MIS]` | 14,00 | 26,89 | 57,65 | **218/440 = 49,5%** | 40,3× | 18,8× |
| | **B 35' `[INF]`** | 19,80 | **39,49** | **86,48** | **115/440 = 26,1%** | **60,5×** | 27,6× |
| **`770202`** US30 (105,2) | A 15' `[MIS]` | 17,00 | 36,80 | 125,75 | **182/446 = 40,8%** | 47,8× | 14,0× |
| | **B 35' `[INF]`** | 22,80 | **53,05** | **188,92** | **122/446 = 27,4%** | **71,8×** | 20,2× |
| **`770260`** US100 (61,2) | A 15' `[MIS]` | 2,70 | 25,80 | 77,30 | **167/447 = 37,4%** | 50,5× | 16,9× |
| | **B 35' `[INF]`** | 3,07 | **38,36** | **117,02** | **94/447 = 21,0%** | **76,5×** | 25,1× |

### 🧪 LA CALIBRAZIONE — e non è un'autoconferma, è un **contro-esempio superato**
`770101` è l'unica sedia dove ho **tutte e due** le misure. Se la ricostruzione fosse una
favola, sulla quota sotto frontiera sbaglierebbe:

| | quota sotto 57,2 |
|---|---:|
| **misurato** sulle 8 gambe vere | **25,0%** |
| **predetto** dalla ricostruzione B (35') | **26,1%** |
| *(predetto dalla ricostruzione A, 15' — la geometria SBAGLIATA)* | *49,5%* |

> 🎯 **Scarto 1,1 punti percentuali. E la lettura A — quella con la geometria sbagliata —
> sbaglia di 24,5 punti.** Il metodo **distingue**: non dà 26% a tutto.
> ⚠️ **n = 8.** È una calibrazione, non una dimostrazione, e va letta così.

---

# 4. 🚦 LA TABELLA CHE DECIDE — stop contro frontiera FTMO

Frontiera = `40 × spread FTMO misurato` · pavimento DURO = `13,3 ×`.

| sedia | simbolo FTMO | **stop mediano** | fonte | **×  su FTMO** | **× su BCM** | **quota sotto frontiera** | verdetto R5 |
|---|---|---:|---|---:|---:|---:|---|
| `770101` DAX | `GER40.cash` | **71,90** `[MIS n=8]` | forward | **50,3×** | 42,3× | **25,0%** (n=8) | 🟢 **PASSA (+26%)** |
| ↳ *geometria VIVA* | | **54,90** `[MIS n=3]` | forward | 🟡 **38,4×** | 33,0× | *1/3* | 🟡 **FILO (−4%)**, ma **meglio** di oggi |
| `770202` Dow | `US30.cash` | **123,80** `[MIS n=446]` | `Studio_U30USD` (range 15' — **prudente**) | 🟢 **47,1×** | 61,9× | **27,4%** (B 35') | 🟢 **PASSA (+18%)** |
| `770260` Nasdaq | `US100.cash` | **83,20** `[INF]` | stima di casa | 🟢 **54,4×** | 46,2× | **21,0%** (B 35') | 🟢 **PASSA (+36%)** |
| ↳ *mia ricostruzione B* | | **117,02** `[INF]` | `Studio_NASUSD` ×√(35/15) | 🟢 **76,5×** | 65,0× | idem | 🟢 **PASSA (+91%)** |
| `771531` EMA200 | `US30.cash` | **104,30** `[MIS n=8]` | forward | 🔴 **39,7×** | 54,9× | 🔴 **50,0%** (n=8) | 🔴 **SOTTO (−1%)** |
| `770511` SuperWave | `US30.cash` | **98,60** `[MIS n=10]` | forward (sl + tp) | 🔴 **37,5×** | 49,3× | 🔴 **60,0%** (n=10) | 🔴 **SOTTO (−6%)** |
| ↳ *mediana di casa n=4* | | **77,10** `[MIS n=4]` | forward (solo sl) | 🔴 **29,3×** | 38,5× | *4/4* | 🔴 **SOTTO (−27%)** |

🟢 **Nessuna delle cinque è sotto il pavimento DURO (13,3×) alla mediana.**
🔴 **Ma `770511` ha una gamba vera a 4,8×**, e `770202`/`770260` hanno un **P10 ricostruito**
a 20,2× e 25,1×: la coda stretta esiste su tutte.

## 4.1 💥 LA SOGLIA DI ROTTURA — a quale spread FTMO ciascuna cade sotto 40×

| sedia | mediana | rompe a spread | **FTMO misurato** | margine |
|---|---:|---:|---:|---:|
| `770202` | 123,80 | **3,09** idx | 2,63 | 🟢 **+17,7%** |
| `770260` | 83,20 | **2,08** idx | 1,53 | 🟢 **+35,9%** |
| `770101` forward | 71,90 | **1,80** idx | 1,43 | 🟢 **+25,7%** |
| `770101` viva | 54,90 | **1,37** idx | 1,43 | 🟡 **−4,2%** |
| `771531` | 104,30 | **2,61** idx | 2,63 | 🔴 **−0,9%** |
| `770511` | 77,10 | **1,93** idx | 2,63 | 🔴 **−26,7%** |

---

# 5. 💸 QUANTO PEGGIORA IL PAYOFF — il conto di primo ordine, coi numeri veri

## 5.1 Lo spread BCM nel periodo dei backtest `[MISURATO su 250 milioni di tick]`

`backtest_pipeline/risultati_archivio/spread_flotta/REFERTO_SPREAD_FLOTTA.txt` +
`spread_orario_{D30EUR,U30USD,NASUSD}.csv` — finestra **2024.09.26 → 2026.06.30**, ora
server BCM, punti indice, `% solo-bid = 0,000` su tutti e tre (⇒ a Model 4 lo spread vero
è stato usato davvero).

| simbolo | ora d'ingresso | **mediana** | P95 | max | riga TUTTO (mediana / P95 / max) |
|---|---|---:|---:|---:|---|
| `D30EUR` | **08** (DAX) | **1,70** | 2,70 | 12,00 | 1,70 / 4,00 / 25,70 |
| `U30USD` | **14** (cash USA) | **2,00** | 3,00 | 🔴 **47,00** | 2,00 / 2,80 / 101,00 |
| `U30USD` | **17** (ora modale `771531`) | **1,90** | 2,00 | 63,00 | — |
| `NASUSD` | **14** (cash USA) | **1,80** | 2,70 | 8,20 | 1,80 / 2,70 / 8,20 |

## 5.2 FTMO contro BCM — **il DAX e il Nasdaq migliorano, il Dow peggiora**

Rapporto misurato **alla stessa ora** (il tick FTMO delle 17:08 locali = **ora 16 server
BCM**, `OraGMT 15:08` + `Assunto_BCM_UTC=+1`):

| | FTMO (n=1 tick) | BCM ora 16 (mediana) | rapporto |
|---|---:|---:|---:|
| `GER40.cash` / `D30EUR` | 1,43 | 1,70 | 🟢 **0,84×** |
| `US30.cash` / `U30USD` | 2,63 | 1,90 | 🔴 **1,38×** |
| `US100.cash` / `NASUSD` | 1,53 | 1,70 | 🟢 **0,90×** |

## 5.3 Il pedaggio per operazione, in **R** — e perché è la sola unità onesta

`lotti = rischio_EUR / (stop × valore_punto)` ⇒ `costo_EUR = spread × valore_punto × lotti
= rischio_EUR × spread / stop`. **Il valore per punto si semplifica**: il pedaggio in
frazione di rischio è **`spread / stop`**, e non dipende né dalla taglia né dal broker.
*(un giro completo compra ad ask e vende a bid: si paga **UNA** volta lo spread — è la
stessa convenzione con cui è definito il 40× di casa)*

| sedia | stop | pedaggio **BCM** | pedaggio **FTMO** | **Δ** | **Δ %** | **in EUR/op a 2,00% su 80.000** |
|---|---:|---:|---:|---:|---:|---:|
| `770101` GER40 | 86,48 | 0,01966 R | 0,01654 R | 🟢 **−0,00312 R** | **−15,9%** | 🟢 **−5,00 €** |
| `770202` US30 | 123,80 | 0,01616 R | 0,02124 R | 🔴 +0,00509 R | **+31,5%** | 🔴 **+8,14 €** |
| `770260` US100 | 83,20 | 0,02163 R | 0,01839 R | 🟢 **−0,00325 R** | **−15,0%** | 🟢 **−5,19 €** |
| `771531` US30 | 104,30 | 0,01822 R | 0,02522 R | 🔴 +0,00700 R | **+38,4%** | 🔴 **+11,20 €** |
| `770511` US30 | 77,10 | 0,02594 R | 0,03411 R | 🔴 +0,00817 R | **+31,5%** | 🔴 **+13,07 €** |

## 5.4 🎯 Tradotto sul PROFIT FACTOR delle celle validate

`GL = profitto/(PF−1)` · `GW = GL × PF` · costo totale nuovo `= n × Δ`. Il PF nuovo sta fra
due estremi (tutto il costo sulle vincenti / tutto sulle perdenti):

| sedia | cella | PF | n | profitto | **PF su FTMO** | **profitto** |
|---|---|---:|---:|---:|---|---:|
| `771531` | OOS r31 (dep. **100.000**, risk **1,0%**, tick) | 1,52365 | 517 | 23.321,47 | 🔴 **1,409 – 1,442** | 🔴 **−15,5%** |
| `770202` | OOS `ptc` `Pass=1` (risk 1,0%, `range 35`, `short 0`) | 1,27013 | 130 | 6.721,93 | 🔴 **1,237 – 1,244** | 🔴 **−9,8%** |
| `770511` | OOS r3 (risk 1,0%, **deposito `[NON DICHIARATO]`**) | 1,60552 | 165 | 746,21 | 🔴 **1,447 – 1,496** ⚠️ | 🔴 **−18,1%** ⚠️ |
| `770101` | — | 1,41105 | 270 | — | 🟢 **MIGLIORA** | 🟢 **+7,3%** *(su payoff 0,0428 R)* |
| `770260` | OOS `Pass=8` | 1,10936 | 94 | — | 🟢 **MIGLIORA** | 🟢 direzione dimostrata |

⚠️ **`770511`: il deposito di quella corsa NON è dichiarato in repo** (lo dice già
`PIANO_CHALLENGE_OTTOBRE_v2.md`). La riga sopra vale **se e solo se** il deposito era
10.000; a 100.000 il payoff per operazione sarebbe 0,0045 R e la sedia sarebbe già in
perdita sul pedaggio BCM, il che **contraddice** il profitto misurato ⇒ 10.000 è la lettura
coerente, ma resta **`[INFERITO]`**.

> ## 🔴 **LA RIGA DEL §5**: su FTMO **tre sedie su cinque stanno sul Dow**, ed è l'unico
> dei tre indici dove lo spread **peggiora** (+38%). Il DAX e il Nasdaq **migliorano**.
> 👉 Il problema di stasera non è «FTMO è caro»: è **«abbiamo concentrato la rosa sul
> simbolo su cui FTMO è caro»**.

---

# 6. 🔧 `InpMinStopPts` — LA MANOPOLA CHE MORDE SULLA FRONTIERA, con la curva

> 🎯 **Questa è la consegna principale.** `InpMaxSpread` filtra lo **spread istantaneo**;
> `InpMinStopPts` filtra lo **STOP**, cioè esattamente il lato sinistro di
> `stop >= 40 × spread`. La frontiera del costo **è già implementata nell'EA, per-trade,
> con il log che lo dice** — ed è **SPENTA**.

## 6.1 Il meccanismo, letto nel sorgente

```mql5
// ABTG_DAX_Apertura_EU.mq5 r.343-346   (identico in Dow r.313-314 e Nasdaq)
input double InpMinStopPts  = 0;     // Floor minimo di STOP in punti. 0=off
input bool   InpSkipIfTight = true;  // stop < floor -> SALTA il trade

// r.1066 / 1090 / 1326 / 1357 (e gemelli negli altri due EA)
if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
  { if(InpSkipIfTight) { skip = true; ... "troppo stretto per lo slippage" }
    else               { sl = entry -+ InpMinStopPts*_Point; dist = InpMinStopPts*_Point; } }
```

🔴 **E la prima cosa da sapere è che le tre sedie NON si comportano allo stesso modo:**

| sedia | `InpMinStopPts` | `InpSkipIfTight` | cosa fa **oggi** il floor | cosa farebbe alzandolo |
|---|---:|---|---|---|
| `770101` | **0,0** | `true` | 🔴 **NO-OP**: con il floor a 0 la condizione `InpMinStopPts > 0` è falsa e il `true` **non si attiva mai** | **SALTA** il trade ⇒ costa **operazioni** |
| `770202` | **500** = 5,00 idx | **`false`** | 🟡 attivo ma a 5,00 idx = **21× sotto** la frontiera US30 | **ALLARGA** lo stop al floor ⇒ costa **0 operazioni**, cambia la geometria |
| `770260` | **500** = 5,00 idx | **`false`** | 🟡 attivo ma a 5,00 idx = **12× sotto** la frontiera US100 | **ALLARGA** ⇒ **0 operazioni perse** |
| `771531` · `770511` | *l'input non esiste* | — | — | — |

> ## 🎯 **Quindi su `770202` e `770260` un floor a 40× NON costa NEMMENO UN'OPERAZIONE: porta lo stop alla frontiera e riduce il lotto in proporzione.** Costa frequenza **solo** se Claudio mette anche `InpSkipIfTight=true`.
> 🔴 **Ma non è gratis lo stesso**: lo stop non sta più sul bordo del range, sta a una
> distanza arbitraria dentro il range ⇒ **la probabilità di essere toccato cambia**, e
> **quella non la so simulare da qui** — `[NON MISURATO]`, serve una corsa (§7.5 P4).

## 6.2 📈 LA CURVA — floor `0 / 20× / 30× / 40×`, misurata

**Fonte**: `backtest_pipeline/risultati_archivio/studio_apertura/Studio_{D30EUR,U30USD,NASUSD}.csv`
— **440 / 446 / 447 giornate** con rottura vera su tick BCM, apertura **08:00 / 14:30 /
14:30 server**, con per ogni giornata **l'ampiezza del range** *e* **l'esito in R**
(`ABTG_Apertura_Study_EA.mq5`). Filtro applicato sullo stop **della cella viva**
(`larghezza + buffer − offset`, §1), lettura **B** (range **35'** scalato `√(35/15)`, che è
la geometria vera della cella).

### 🔴 LEGGERE PRIMA: che cosa è trasferibile e che cosa NO
| grandezza | trasferibile alla cella viva? |
|---|---|
| **`n` superstiti / % della base** | 🟢 **SÌ** — il floor agisce sull'ampiezza del range, che è lo **stesso oggetto** nelle due geometrie |
| **PF · R/op · DD** | 🔴 **NO, solo la DIREZIONE** — lo Studio è un breakout **cieco** (TP fisso 2R, due lati, nessun filtro EMA/volumi/ritardo, nessun parziale, nessun trailing): **non è la cella**. I suoi PF stanno fra 1,00 e 1,13, quelli delle celle fra 1,11 e 1,52 |

### `770101` DAX · `GER40.cash` · spread FTMO **1,43** · `SkipIfTight = TRUE` ⇒ **salta**

| floor | in idx | **n superstiti** | **% base** | win% | tot R | R/op | PF proxy | DD max proxy |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **0** (oggi) | — | 440 | 100,0% | 36,4% | 11,2 | 0,026 | 1,042 | 46,1 R |
| 20× | 28,60 | 428 | **97,3%** | 36,4% | 11,2 | 0,026 | 1,043 | 46,1 R |
| 30× | 42,90 | 387 | **88,0%** | 36,2% | 4,2 | 0,011 | 1,018 | 34,1 R |
| **40×** | **57,20** | **325** | 🔴 **73,9%** | 37,8% | 15,2 | 0,047 | **1,080** | 🟢 **21,1 R** |

### `770202` Dow · `US30.cash` · spread FTMO **2,63** · `SkipIfTight = FALSE` ⇒ **allarga**

| floor | in idx | n superstiti *(se si mettesse `SkipIfTight=true`)* | % base | win% | tot R | R/op | PF proxy | DD max proxy |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **0**/500 (oggi) | 5,00 | 446 | 100,0% | 41,5% | 33,1 | 0,074 | 1,134 | 16,7 R |
| 20× | 52,60 | 403 | **90,4%** | 42,7% | 37,1 | 0,092 | 1,171 | 10,4 R |
| 30× | 78,90 | 353 | **79,1%** | 42,5% | 23,0 | 0,065 | 1,121 | 11,6 R |
| **40×** | **105,20** | **324** | 🟡 **72,6%** | 43,8% | 28,0 | 0,086 | **1,166** | 🟢 **10,4 R** |

### `770260` Nasdaq · `US100.cash` · spread FTMO **1,53** · `SkipIfTight = FALSE` ⇒ **allarga**

| floor | in idx | n superstiti *(se si mettesse `SkipIfTight=true`)* | % base | win% | tot R | R/op | PF proxy | DD max proxy |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **0**/500 (oggi) | 5,00 | 447 | 100,0% | 37,8% | 0,3 | 0,001 | 1,001 | 36,8 R |
| 20× | 30,60 | 415 | **92,8%** | 38,6% | 5,3 | 0,013 | **1,022** | 32,8 R |
| 30× | 45,90 | 385 | **86,1%** | 37,9% | −6,2 | −0,016 | 🔴 **0,973** | 35,8 R |
| **40×** | **61,20** | **353** | 🟡 **79,0%** | 38,5% | −4,2 | −0,012 | 🔴 **0,980** | 32,8 R |

## 6.3 🎯 LE TRE COSE CHE QUESTA CURVA DICE — e una non me l'aspettavo

1. 🔴 **Il floor a 40× costa fra il 21% e il 26% delle operazioni** (325/440 · 324/446 ·
   353/447), e il pavimento di frequenza è **1,00 op/g per famiglia** (firma 07/09).
   Su sedie che oggi stanno a **0,97 / 0,46** op/g, togliere un quarto delle operazioni è
   **un costo vero, non un dettaglio**.
2. 🟢 **Dove il floor paga, paga sul RISCHIO più che sul merito**: sul DAX il DD del proxy
   scende da **46,1 R a 21,1 R (−54%)** e sul Dow da 16,7 a 10,4 R (−38%), mentre il PF si
   muove di poco (1,042→1,080 · 1,134→1,166). 📌 **È esattamente l'asimmetria misurata in
   R118**: la larghezza dello stop compra rischio in modo riproducibile e paga in edge in
   modo non riproducibile — **qui col segno girato, ed è coerente.**
3. 🔴 **E LA SORPRESA, che va detta perché smonta il «floor = sempre meglio»: sul Nasdaq il
   floor PEGGIORA il PF.** 1,001 → **0,980** a 40×, e la curva non è nemmeno monotona
   (20× dà 1,022, 30× dà 0,973). Le giornate a range stretto, sul Nasdaq, **non erano le
   peggiori**. 👉 Proporre 40× su `770260` «perché è la regola» sarebbe **esattamente il
   difetto che la regola di casa vieta**: girare una manopola senza il numero.
   ⚠️ E la non-monotonia dice anche un'altra cosa: **su un proxy con PF ~1,00 questi Δ sono
   rumore.** Il verso è affidabile solo sul DD, dove è grande e concorde.

## 6.4 ⚠️ LO SLIPPAGE DENTRO IL FLOOR — dichiarato, perché il commento del codice lo chiede

Il codice dice: *«floor minimo di STOP ~ spread + slippage + cuscinetto»*.
**Nei numeri del §6.2 c'è dentro SOLO LO SPREAD.** Il 40× è `40 × spread`, come da regola
di casa. Lo slippage **non** è dentro, e va detto:

| | valore | etichetta |
|---|---|---|
| slippage d'**ingresso** misurato in casa | **+0,70 punti indice, avverso** — `D30EUR`, magic `770101`, conto REALE, 08/09 | 🔴 `[MISURATO, n=1]` — `report/IL_PRIMO_SLIPPAGE_VERO_2026-09-11.md` |
| slippage sulle **uscite in stop** | 🔴 **`[NON MISURATO]`** (n=1, scarto 0,00) | — |
| slippage su **FTMO** | 🔴 **`[NON MISURATO]`** — nessun deal | — |
| `InpSlippagePts` nei preset FTMO | **0,0** su tutte e tre ⇒ **non modellato** | `[MISURATO]` |

🧮 **E quanto costerebbe metterlo dentro**, sull'unico simbolo dove ho il numero:
pedaggio completo GER40 = `1,43 + 0,70 = 2,13` idx ⇒ floor 40× = **85,20** invece di 57,20.

| floor `770101` | n superstiti | % base | tot R | PF proxy | DD max proxy |
|---|---:|---:|---:|---:|---:|
| 40× **solo spread** = 57,20 | 325 | 73,9% | 15,2 | 1,080 | 21,1 R |
| 40× **spread + slippage** = 85,20 | **223** | 🔴 **50,7%** | 12,3 | 1,097 | 🟢 **12,3 R** |

> 🔴 **Mettere lo slippage dentro il floor DIMEZZA le operazioni del DAX.** Con n=1 al
> numeratore, **non lo propongo**: lo scrivo perché sia una decisione, non una svista.

## 6.5 ✍️ LA PROPOSTA SU `InpMinStopPts` — e stasera è «non toccare»

| sedia | valore oggi | **proposta per STASERA** | **proposta dopo P1/P4 (§7.5)** | perché |
|---|---:|---|---|---|
| `770101` | 0,0 (no-op) | 🟢 **lasciare 0** | **2860** (20×) o **5720** (40×) | a 20× costa **2,7%** di operazioni e non cambia niente; a 40× costa **26%** — **serve il numero sulla cella vera, non sul proxy** |
| `770202` | 500 | 🟢 **lasciare 500** | **10520** (40×) *con* `SkipIfTight=false` = **0 operazioni perse** | è l'unico caso in cui il floor è **gratis in frequenza**, ma cambia la geometria dello stop: **una corsa lo dice** |
| `770260` | 500 | 🟢 **lasciare 500** | 🔴 **NON alzare a 40×** | sul proxy il PF **peggiora** (1,001 → 0,980). Se si alza, **3060 (20×)** è l'unico gradino che migliora |
| `771531` · `770511` | — | l'input **non esiste**: 🔴 la frontiera su quelle due **non ha manopola**. L'unica leva è `InpSLBufferAtr` su SuperWave (r.80, oggi **0**, mai messa ad asse) | | |

> 🔴 **Perché «non toccare stasera» è la proposta giusta e non pigrizia**: alzare il floor
> è un **cambio di cella**. La cella promossa dai round è quella con `InpMinStopPts=0`/`500`;
> una cella con floor a 40× **non è mai stata girata a tick reali**, e il numero che ho
> è un **proxy con PF 1,00-1,17 che non è la cella**. Accendere stasera una cella mai
> validata, sulla challenge pagata, per rispettare un pavimento di lavoro, sarebbe
> **peggio** del problema che risolve.

---

# 6-bis. 🎚️ `InpMaxSpread` — LA RETE SECONDARIA

## 6-bis.1 Che cosa fa davvero, verificato nel codice

```mql5
bool SpreadOK(){ if(InpMaxSpread<=0) return(true);
                 return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD) <= InpMaxSpread); }
```
`ABTG_EMA200.mq5` r.507 (chiamata r.325) · `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.563
(r.317) · i tre Apertura lo chiamano in **6-7 punti** ciascuno, fra cui l'armamento del
RETEST (`ABTG_Nasdaq_Apertura_US.mq5` r.1505, `Dow` r.1278, `DAX` r.1441).

- ✅ **Unità: PUNTI MT5.** Su questi sei simboli **1 punto indice = 100**.
- 🔴 **`0` su tutte e sei = filtro SPENTO**, confermato riga per riga.
- 🔴 **Limite**: sulle tre Apertura il controllo avviene **all'ARMAMENTO** (fine del range),
  **non al riempimento** — e l'ingresso è un **LIMIT**. Protegge dalla giornata storta,
  **non dal tick storto sul fill**.
- 🔴 **E soprattutto: NON alza lo stop.** Una giornata a range stretto passa il filtro dello
  spread e resta sotto la frontiera lo stesso. È una rete, non la frontiera.

## 6-bis.2 Quanto costa una soglia — **misurato**

Fonte: `data/spread_vivo/SPREAD_VIVO_2026-09-12_istogramma.csv`, righe
`BIN,<sym>,<ora>,<spread in punti MT5>,<conteggio>` (BCM **vivo**, 04→11/09/2026).

| simbolo · ora | n campioni | mediana | P95 | P99 | max | bloccati a 300 | a 400 | a 600 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `D30EUR` ora 8 | 3.596 | 160 | 170 | 170 | **170** | 0,00% | 0,00% | 0,00% |
| `NASUSD` ora 14 | 3.578 | 180 | 190 | 190 | **190** | 0,00% | 0,00% | 0,00% |
| `U30USD` ora 14 | 3.578 | 300 | 300 | 300 | **900** | 0,31% | 0,31% | 0,06% |
| `U30USD` ore 1-21 | 72.240 | 200 | 300 | 300 | **3.000** | 0,52% | 0,52% | 0,52% |
| `U30USD` 24h | 79.138 | 200 | 300 | 700 | **3.000** | 1,88% | 1,88% | 1,03% |

## 6-bis.3 🎯 LE SEI PROPOSTE — **numero, derivazione, costo**

Regola di derivazione, dichiarata prima dei valori: **soglia = `P95` dello spread BCM
all'ora di lavoro × il rapporto FTMO/BCM misurato (§5.2), arrotondato in su a 10 punti
MT5** — cioè *«blocca la coda, non la mediana»*.

| sedia | simbolo | P95 BCM (ora) | × rapporto | **PROPOSTA `InpMaxSpread`** | in idx | **costo misurato** |
|---|---|---:|---:|---:|---:|---|
| `770101` | `GER40.cash` | 2,70 (ora 8) | 0,84 | **230** | 2,30 | 🟢 **0,00%** dei campioni BCM · su FTMO taglia **60% sopra** il tick misurato |
| `770202` | `US30.cash` | 3,00 (ora 14) | 1,38 | **420** | 4,20 | 🟢 **0,31%** · lascia passare fino a **1,6×** il tick misurato |
| `770260` | `US100.cash` | 2,70 (ora 14) | 0,90 | **250** | 2,50 | 🟢 **0,00%** · **1,6×** il tick misurato |
| `771531` | `US30.cash` | 3,00 (banda 1-21) | 1,38 | **420** | 4,20 | 🟢 **0,52%** |
| `770511` | `US30.cash` | 3,00 (24h) | 1,38 | **420** | 4,20 | 🟢 **1,88%** |
| `770411` | `GER40.cash` | 2,70 (ora 7-8) | 0,84 | **230** | 2,30 | 🟢 **0,00%** *(fuori rosa stasera, per completezza)* |

🔴 **Il contro-esempio che mi ha corretto**: la mia prima derivazione su `771531` usava il
P95 dell'**ora modale 17** (2,00 → **280** punti). **Misurata sul campione vivo, quella
soglia blocca il 43,6% dei campioni**, perché `771531` è una sedia **H1 che lavora su tutta
la banda 01-21**, non solo alle 17. La soglia giusta è quella della **banda**: **420**.
*(Senza il controllo del costo avrei proposto un numero che dimezza la frequenza della
sedia con la frequenza migliore della rosa — 1,55 op/g, l'unica sopra il pavimento da sola.)*

⚠️ **E il limite di tutte e sei**: sono derivate da una distribuzione **BCM** riscalata con
**un rapporto misurato su UN tick FTMO**. Dopo **P1** (§7.5) si rifanno sul P95 vero di
FTMO, e allora sono misure invece che derivazioni.

---

# 7. 🧪 IL CONTRO-ESEMPIO — quello che farebbe cadere questo referto

## 7.1 ❓ *«Dici che `770202` e `770260` passano. Ma la frontiera la costruisci su UN TICK.»*

🔴 **È l'obiezione giusta, e non la supero: la accolgo.**

- Il tick FTMO è delle **17:08 locali = ora 16 server BCM**. Sui tick storici BCM l'ora 16
  è, sui tre indici, **fra le più strette della giornata**.
- **`770202` e `770260` entrano alle 14:30 server BCM**, nell'apertura cash. Lì il massimo
  BCM su `U30USD` è **47,00 punti indice** (23× la mediana) e il P95 è **3,00**.
- 🔴 **A 4,15 punti indice** (= P95 BCM ora 14 × 1,38) **`770202` fa 29,8×** e cade sotto.
  **A 2,43** (= P95 NASUSD × 0,90) **`770260` fa 34,2×** e cade sotto.

> ## 🔴 **VERDETTO ONESTO: i due PASS reggono ALLA MEDIANA e CADONO AL P95.**
> Nel vocabolario R5 congelato il 18/09 questo si chiama **🟡 FRAGILE**, non 🟢 PASS.
> **E per saperlo davvero serve una cosa sola: lo spread FTMO MISURATO all'apertura.**

## 7.2 ❓ *«Se `771531` e `770511` non reggono, perché il forward su BCM ha funzionato?»*

Tre risposte misurate, e nessuna è «il cancello sbaglia»:

1. 📉 **Su BCM il pedaggio era più basso del 38% e del 31%** (§5.3). `771531` girava a
   **54,9×**, cioè **+37% sopra** il pavimento. Su FTMO va a 39,7×: **non è la sedia che è
   cambiata, è il pedaggio**.
2. 🔬 **Il forward non ha mai provato niente a 40×**: `771531` ha **21 operazioni** in
   archivio, `770511` **16**, `770202` **7**, `770260` **0**. Il PF che le ha validate viene
   dai **backtest a tick reali su spread BCM**, non dal campo.
3. ⚖️ **E il pavimento 40× NON è il pareggio.** È il pavimento di **lavoro** di casa; il
   pavimento **duro** è 13,3×. `771531` a 39,7× **guadagna ancora**: perde il **15,5%** del
   profitto e scende da PF 1,52 a **1,41-1,44**. 👉 **«Sotto la frontiera» vuol dire
   "il pedaggio si mangia una fetta dichiarata dell'edge", non "va in perdita".**

## 7.3 ❓ *«La ricostruzione dello stop dallo Studio è una favola per far quadrare i conti»*

Provata contro i numeri veri di qualcun altro, non contro sé stessa: **§3.5**, predetto
26,1% contro misurato 25,0% su `770101`, con la geometria sbagliata (15') che sbaglia di
24,5 punti. E lo Studio è un **file scritto da un'altra sessione** (26/08), per un altro
scopo, che non sapeva di questa domanda.

## 7.4 ⚪ COSA QUESTO REFERTO **NON** COPRE

1. 🔴 **Lo spread FTMO come DISTRIBUZIONE**: ho **un tick**. Mediana, P95 e comportamento
   all'apertura sono **`[NON MISURATO]`**.
2. 🔴 **Le COMMISSIONI FTMO sugli indici**: `[NON MISURATO]`. Il CSV di prevolo non ha il
   campo. R5 è definito su `spread + commissione`: **se FTMO addebita commissione sui
   CFD indici, ogni × di questo referto scende.**
3. 🔴 **Lo SWAP/rollover FTMO**: `[NON MISURATO]`. Tocca `771531` e `770511` (H1, tengono
   la notte).
4. ⚪ Requote, rifiuti, slippage di esecuzione: **fuori misura**, su tutti e due i broker.
5. ⚪ Il pedaggio dell'**uscita** quando è a mercato (flat di fine sessione): l'ora
   dell'uscita è `[NON MISURATO]` su tutte e cinque — è un limite ereditato da R5.
6. ⚪ `770202` e `770260` restano **senza una sola gamba in stop vera**. La ricostruzione è
   solida ma **non è una gamba misurata**.

## 7.5 🛠️ LA VIA PIÙ CORTA AI NUMERI CHE MANCANO — preparata, non eseguita

| # | che cosa | come | costo |
|---|---|---|---|
| **P1** 🥇 | **spread FTMO per ora, vero** | `ABTG_SpreadTick` / `ABTG_SpreadOrario` sui tick storici di `GER40.cash`, `US30.cash`, `US100.cash` — 🖥️ **finestra PowerShell sul VPS, terminale FTMO `541452707` (`C:\FTMO`)**, **nessun altro terminale toccato** | **~10 min**, sola lettura, **zero backtest** |
| **P2** | **spread FTMO in accumulo** | `ABTG_SpreadLogger` su un grafico FTMO (come già fatto su BCM: produce esattamente l'istogramma del §6.2) | continuo, zero impatto |
| **P3** | commissione indici FTMO | una posizione da `VolMin` 0,01 e la colonna commissione dell'estratto conto — **firma di Claudio** | 1 operazione |
| **P4** 🥈 | gambe in stop vere di `770202`/`770260` **E** PF/DD veri del floor sulla cella | round per-trade già **scritto e pronto**: `backtest_pipeline/prove/R152a_pertrade_DowApertura_770202.txt`, da rilanciare con `InpMinStopPts` come **asse** (0 / 20× / 30× / 40×) invece che pinnato | 1 corsa del tester, 4 passate per sedia |
| **P5** | ✅ **FATTO IN QUESTO REFERTO** — costo in operazioni di `InpMinStopPts` | contate sulle colonne `ampiezza_pt` degli `Studio_*.csv`: **§6.2** | **0 macchina** |
| **P6** | slippage FTMO | `ABTG_SlippageLogger` sul terminale FTMO, come già su `C:\BCM_Reale` | continuo, zero impatto |

---

# 8. 📌 IL QUADRO FINALE, ogni numero con la sua etichetta

| # | numero | valore | etichetta |
|---|---|---|---|
| 1 | `InpSLMode=0` sulle tre Apertura | **`ABTG_SL_RANGE`, non ATR** | `[MISURATO — sorgente r.236-237]` |
| 2 | `InpAtrSlMult=1.5` su quelle tre | **manopola INERTE** | `[MISURATO]` |
| 3 | `Digits`/`Point` BCM vs FTMO | **identici (2 · 0,01)** su tutti e sei | `[MISURATO, 2 sonde]` |
| 4 | EUR/punto indice/lotto | D30EUR 1,000 = GER40 1,000 · U30USD 0,861 vs US30 0,871 · NASUSD 0,867 vs US100 0,871 | `[MISURATO, n=154/62/59]` |
| 5 | stop `770101` | med **71,90** · P10 54,12 · min 52,30 | `[MISURATO, n=8]` |
| 6 | stop `770101` geometria VIVA | med **54,90** | `[MISURATO, n=3]` |
| 7 | stop `771531` | med **104,30** · P10 71,17 · min 65,50 | `[MISURATO, n=8]` |
| 8 | stop `770511` | med **98,60** · P10 50,77 · min **12,70** | `[MISURATO, n=10 gambe / 6 segnali]` |
| 9 | stop `770202` da forward | 🔴 **`[NON MISURATO]`** — 0 gambe in stop | — |
| 10 | stop `770260` da forward | 🔴 **`[NON MISURATO]`** — 0 operazioni | — |
| 11 | stop `770202` ricostruito | med **188,92** (35') / 125,75 (15') | `[INFERITO]` / `[MISURATO]` |
| 12 | stop `770260` ricostruito | med **117,02** (35') / 77,30 (15') | `[INFERITO]` / `[MISURATO]` |
| 13 | quota sotto frontiera | `770101` **25,0%** · `771531` **50,0%** · `770511` **60,0%** · `770202` **27,4%** · `770260` **21,0%** | `[MIS]` le prime tre, `[INF]` le altre due |
| 14 | spread FTMO | **n = 1 tick**, ora 16 BCM | 🔴 `[MISURATO, n=1]` |
| 15 | commissioni / swap FTMO | 🔴 **`[NON MISURATO]`** | — |
| 16 | Δ pedaggio FTMO−BCM | GER40 **−15,9%** · US100 **−15,0%** · US30 **+31,5% / +38,4%** | `[MISURATO]` |

---

### 🔒 PERIMETRO
Sessione in **SOLA LETTURA**. Nessun `.set`, nessun `.mq5`, nessun `.ini`, nessun
terminale, nessuna taglia, nessun magic, nessun backtest. Scritti: **questo file** e la
classe nuova in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
Letti: 2 CSV di statement, 5 sorgenti MQL5, 10 preset, 6 CSV di spread, 3 CSV dello Studio
delle aperture, 8 referti.
**`InpMaxSpread` e `InpMinStopPts` sono PROPOSTI. La firma è di Claudio.**

*Referto del 20/09/2026.*
