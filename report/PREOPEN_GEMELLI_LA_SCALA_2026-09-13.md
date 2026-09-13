# 🔬 PREOPEN — LA VOCE 4 (GEMELLI): **la scala NON si deriva, si MISURA**

**Turno notturno del 13/09/2026.** Perimetro: nessun backtest, solo archivio e
preparazione. Committente: la **voce 4** del certificato di morte del meccanismo
pre-apertura `ABTG_Nasdaq_Live5m` (magic **770203**), oggi ⚪ `[NON ANCORA MISURATO]`.

> ## 🎯 LA RISPOSTA IN UNA RIGA
> **Il fattore di scala per il cancello 17-40 NON esiste in archivio, e le due
> ancore disponibili DIVERGONO del 16-48%.** Ma non serve: si smette di DERIVARE
> il cancello e si MISURA la distribuzione che il cancello taglia — **e il codice
> lo permette senza toccare una riga.** Tre file prova pronti, **42 passate,
> 3,83 minuti**. 🔴 **SPXUSD resta fuori: spread `[NON MISURATO]`.**

---

## 0. 🔴 PRIMA DI TUTTO: **DUE CORREZIONI AL DOSSIER DEL 12/09**

### C-1 · «il gemello DAX e' girato col cancello SPENTO» — **VERO A META'**
Il verdetto v2 (§7, riga voce 4) dice che `ABTG_DAX_Live5m` r.32-33 ha
`MINRANGE 0`/`MAXRANGE 0` e che quindi *"il cancello era SPENTO sul gemello"*.
E' vero per **quell'EA** e per la griglia a 32 celle
(`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv`:
`InpMinRangePts=0` su **tutte e 32** le righe).

🔴 **Ma e' FALSO per la corsa walkforward del motore `v2`**, che nessuno aveva
aperto. `risultati_prove/ABTG_DAX_Live5m_v2/ABTG_DAX_Live5m_v2_D30EUR_*.csv`:

| | `InpMinRangePts` | `InpMaxRangePts` | `RangeMode` | `PrevWin` | `SessionHour` | `Buffer` | rischio |
|---|---:|---:|---:|---:|---:|---:|---:|
| corsa v2 | **1500** | **4000** | 1 | 5 | 8 | 700 | **1** |

**IL CANCELLO ERA ACCESO**, a **15-40 punti indice**, sulla candela
07:55-08:00 server del DAX. E i numeri ci sono, a tick reali:

| finestra | PF | n (deal) | DD% | Profit |
|---|---:|---:|---:|---:|
| IS | **1,00564** | 80 | 4,7022 | +11,10 |
| **OOS** | **0,92490** | **202** | 14,1590 | −393,74 |

🟢 **E la gestione e' IDENTICA alla cella Nasdaq**, verificata colonna per colonna:
`TP1_R 1 · ClosePct 50 · BE 1 · Trailing 1 · TrailStartR 0 · TrailMode 1 ·
TrailTF M1 · SLMode 0 · EntryMode 0 · LevelTF 16385 · PendingExpiry 120`.

🔴 **I confondimenti, nominati tutti e tre** (e nessuno e' piccolo):
1. **rischio 1% contro 2%** — e il PF **non si trasferisce** fra taglie
   (`CalcLotByRisk` dimensiona su `ACCOUNT_BALANCE`, r.863-864: capitale composto);
2. il motore `v2` ha **114 righe in piu'** e paga `InpSlippagePts=100`, cioe'
   **un punto indice di slippage** che la corsa Nasdaq **non paga**;
3. `CloseHour` **17:30** contro **20:45**.

👉 **Perche' conta lo stesso**: accendere il cancello sul DAX ha portato il PF OOS
da **0,85701** (cancello spento, rischio 2%, EA puro) a **0,92490**, tagliando l'n
da **342** a **202** (**−41%**). 🔥 **IL CANCELLO MORDE, e morde nel verso giusto.**
Non basta per 1,10, ma dice che l'asse proposto qui sotto **non sara' piatto**.

### C-2 · **due manopole inerti trovate LEGGENDO, non girando**
Nella griglia a 32 celle di `Live5m_v2`: **32 passate → OTTO esiti distinti**.
`InpMinStopPts` (200/400) e `InpSkipIfTight` (0/1) producono **quattro repliche
identiche al quinto decimale** per ogni cella vera. E il motivo sta nel codice,
non nei dati: `ABTG_DAX_Live5m_v2.mq5` r.678 applica un floor di **200 punti MT5
= 2 punti indice**, mentre lo stop e' **almeno il buffer**, che vale **500 o 700**.
🔴 **Quel floor non puo' mordere MAI.** Sono due caselle **libere per costruzione**,
non due caselle provate. (Esattamente il pattern degli 874 CSV del censimento 09/09.)

---

## 1. 📏 PASSO 1 — **LA CONVERSIONE, simbolo per simbolo, con file:riga**

| simbolo | 1 punto indice = ? punti MT5 | fonte | esito |
|---|---:|---|---|
| **NASUSD** | **100** | `risultati_archivio/spread_flotta/REFERTO_SPREAD_FLOTTA.txt` (*"conversione : 1 pto indice = 100 pti MT5; point=0.01000"*) **+** `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` (intestazione NASUSD) | 🟢 **MISURATO**, due fonti indipendenti |
| **U30USD** | **100** | stesse due fonti, sezione U30USD | 🟢 **MISURATO** |
| **D30EUR** | **100** | stesse due fonti (*"D30EUR (vivo, 2 decimali, 1 punti indice = 100 punti MT5)"*) | 🟢 **MISURATO** |
| **SPXUSD** | **100** | 🔴 **assente da entrambe.** Ricavato da `data/statements/trades_auto.csv` r.188 e r.895 | 🟡 **[DERIVATO]**, n=2 |

### 🧪 Il contro-esempio su SPXUSD, perche' un [DERIVATO] va rotto prima di usarlo
Le due sole operazioni SPXUSD vere in archivio:
```
r.188  sell 0.20  7122.90 -> 7136.90   profit -2.39 EUR   (2026.04.24)
r.895  sell 0.60  7494.20 -> 7488.90   profit +2.78 EUR   (2026.07.09)
```
**Ipotesi alternativa da battere: e se fosse 10 punti MT5 per punto indice?**
- riconciliazione r.188: 14,00 idx × 0,20 lotti × 1 USD/idx = **2,80 USD** → per fare
  **2,39 EUR** serve EURUSD **1,1715**;
- riconciliazione r.895: 5,30 × 0,60 = **3,18 USD** → per **2,78 EUR** serve **1,1439**.

🟢 **Due tassi plausibili e DIVERSI su due date a 2,5 mesi di distanza** (+2,4%, la
deriva del cambio). Con un fattore 10 i prezzi sarebbero quotati a un decimale e
l'S&P starebbe a 712 invece che a **7.123**: assurdo. Con 1000, a 71.230. 👉 **100 e'
l'unico valore che regge, ma resta `[DERIVATO]` da n=2, non misurato.**

---

## 2. 💰 IL PREZZO MEDIANO — **e qui c'e' un numero del dossier da correggere**

| simbolo | prezzo mediano **operazioni vere** | n op | giorni | finestra |
|---|---:|---:|---:|---|
| NASUSD | **29.059,3** | 59 | 25 | 2026.05.05 → 2026.09.11 |
| D30EUR | **25.422,7** | 163 | 50 | 2026.04.20 → 2026.09.11 |
| U30USD | **53.465,1** | 74 | 24 | 2026.07.27 → 2026.09.08 |
| SPXUSD | **7.308,5** | 🔴 **2** | 2 | 2026.04.24 → 2026.07.09 |

_(fonte: `data/statements/trades_auto.csv`, colonna `open_price`)_

### 🔴 MA IL PREZZO MEDIANO **NELLA FINESTRA DI BACKTEST** E' UN ALTRO NUMERO
`backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`,
colonna `apertura`, **445 giornate `OK`** fra 2024.09.26 e 2026.06.30:

> **NASUSD, prezzo mediano NELLA FINESTRA = 23.328** (min 16.784 · max 30.708)

**Contro 29.059 delle operazioni vive: +24,6% di differenza sullo stesso simbolo.**
Conseguenza diretta sul cancello:

| lettura | 17 idx | 40 idx |
|---|---:|---:|
| % del prezzo **VIVO** (29.059) — quella scritta nel dossier v2 | 0,0585% | 0,1376% |
| % del prezzo **NELLA FINESTRA** (23.328) — quella in cui i numeri OOS sono stati misurati | **0,0729%** | **0,1715%** |

👉 **Il «0,059% - 0,138%» del dossier e' il cancello letto col prezzo di OGGI, non
col prezzo della finestra in cui il PF 0,96265 e' stato misurato.** Non ribalta
niente, ma e' un'ancora che si muove del 25% e va detta.
🔴 Per **D30EUR / U30USD / SPXUSD** il prezzo mediano **nella finestra** e'
`[NON MISURATO]`: l'unico file per-giorno in archivio e' quello del Nasdaq.

---

## 3. 🕳️ L'AMPIEZZA DELLA CANDELA M5 PRE-APERTURA: **`[NON MISURATO]`, su TUTTI E QUATTRO**

Ho cercato in `studio_apertura/`, `spread_flotta/`, `risultati_archivio/` e nel
codice di `anatomia_aperture.py`. **Il numero non esiste.** Quello che esiste:

| cosa c'e' | cos'e' DAVVERO | fonte |
|---|---|---|
| `Studio_*.csv` colonna `ampiezza_pt` | ampiezza dei **primi 15 minuti DOPO** l'apertura, **non** la pre-apertura | `ABTG_Apertura_Study_EA.mq5` r.163-169: il range e' `[openMin, openMin+InpRangeMinutes)`, con `InpRangeMinutes=15` (`studio_apertura.ps1` r.130) |
| `ANATOMIA_..._PERGIORNO_NASUSD.csv` colonna `pre_amp_pt` | pre-apertura ma di **60 MINUTI**, e **solo NASUSD** | `anatomia_aperture.py` r.125 `DEF_MINUTI_PRE = 60`; la colonna `barre_pre` della corsa archiviata vale 49-60 |

### ✅ Il flag `--minuti-pre` **ESISTE** — ma la corsa a 5 minuti non e' mai stata fatta
`anatomia_aperture.py` r.1650: `ap.add_argument("--minuti-pre", ...)`. Accetterebbe 5.
🔴 **Ma i file M1 sul PC di backtest non coprono i simboli giusti**
(`report/STORICO_INDICI_SCARICATO_2026-09-10.md`):

| simbolo | M1 disponibile | utile per la nostra finestra? |
|---|---|---|
| NASUSD | 2010.11 → 2026.08 | 🟢 **SI** |
| SPXUSD | 2010.11 → 2026.08 | 🟢 SI (ma serve lo spread, che manca) |
| D30EUR | 2010.11 → **2018.12** | 🔴 **NO** — si ferma 6 anni prima |
| U30USD | 🔴 **non scaricato** | 🔴 **NO** — *"HistData non ha il Dow"* |

📌 **Numero di riferimento comunque utile**: la pre-apertura da **60 minuti** del
Nasdaq nella finestra ha mediana **71,70 punti indice = 0,2994% del prezzo**
(445 giornate). Con la regola `range(t) ≈ range(giorno)×√(t/1440)` (validata al
4,3% in `ORO_1530_CANCELLO_COSTO`), √(5/60) = 0,2887 → **~20,7 idx** per 5 minuti,
**dentro la banda 17-40**. 🟡 E' un'estrapolazione di **fattore 12**: sta scritta
come coerenza, **non** come misura.

---

## 4. ⚖️ PASSO 2 — LE ANCORE, **e il fatto che LITIGANO**

### Ancora A — **PREZZO** (mediana operazioni vere)
### Ancora B — **VOLATILITA' D'APERTURA** (mediana dell'ampiezza dei primi 15')

| simbolo | rapporto **A** (prezzo) | cancello A | rapporto **B** (volatilita') | cancello B | 🔴 divergenza sul pavimento |
|---|---:|---:|---:|---:|---:|
| **D30EUR** | 0,8749 | **14,9 – 35,0** | 0,7258 | **12,3 – 29,0** | **+20,5%** |
| **U30USD** | 1,8399 | **31,3 – 73,6** | 1,5903 | **27,0 – 63,6** | **+15,7%** |
| **SPXUSD** | 0,2515 | 4,3 – 10,1 | 0,1693 | 2,9 – 6,8 | 🔴 **+48,5%** |

**Ancora C — ATR**: `[NON MISURATO]` su questa finestra e su questi simboli.
Non l'ho inventata.

### 🧪 Il contro-esempio sull'ancora B, prima di usarla
**Ipotesi alternativa: e se `ampiezza_pt` differisse fra simboli per la COPERTURA
dei dati, non per la volatilita'?** Il numero e' condizionato ai giorni con
breakout, e su un simbolo con storico bucato uscirebbe un valore che non descrive
niente. **Misurato:** n = **447 (NASUSD) · 446 (U30USD) · 444 (SPXUSD) · 440 (D30EUR)**.
La finestra `2024.01.01 → 2026.06.30` dichiarata in `studio_apertura.ps1` r.121-122
e' **tagliata dai dati**, che su BCM partono il 26/09/2024: **642 giorni di
calendario ≈ 445 sedute.** 👉 **Copertura ~100% su tutti e quattro, praticamente
nessun condizionamento, e la finestra E' la nostra.**
🟢 **E il canarino funziona**: nello stesso file `E35EUR` fa **211** — storico
bucato, e infatti non e' uno dei nostri. **Contro-esempio superato.**

### 🚫 E allora quale ancora si sceglie? **NESSUNA.**
Scegliere l'ancora A perche' e' l'unica «comoda», o la B perche' «sembra piu'
fisica», sarebbe **inventare un fattore di scala** — e un numero inventato che fa
partire un round produce una misura che non descrive il gemello. **Peggio di non
averla.**

---

## 5. 🔥 PASSO 3 — **LA VIA CHE NON INVENTA NIENTE: si misura la distribuzione**

`ABTG_Nasdaq_Live5m.mq5` r.639-640:
```
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(...); return(true); }
```
Il filtro sta **PRIMA** di `SpreadOK()` (r.644) e di `TrendBias()` (r.649), e tutti
gli altri filtri sono pinnabili spenti. 👉 **Quindi `n(soglia)` e' la FUNZIONE DI
SOPRAVVIVENZA PURA dell'ampiezza della candela pre-apertura**: quante giornate
hanno ampiezza ≥ x.

> ### 🎯 **Con la stessa curva misurata su tre simboli, il cancello del gemello non
> si DERIVA piu': si prende la soglia che taglia la STESSA FRAZIONE DI GIORNATE
> che 17 taglia sul Nasdaq.** Quella e' una **misura**, non un fattore di scala.

E il round **restituisce gratis la misura mancante** del §3: la distribuzione
dell'ampiezza della candela pre-apertura, campionata ogni 5 punti indice.

### 📐 Le tre griglie — e ognuna **copre tutte e tre le risposte**, senza sceglierne una

| file | simbolo | asse `InpMinRangePts` (punti MT5) | celle | cosa copre |
|---|---|---|---:|---|
| **R143a** | NASUSD | `1700 \|\| 0 \|\| 850 \|\| 3400` → 0·850·1700·2550·3400 | **5** | **1700 cade esatto**: e' il valore live |
| **R143b** | D30EUR | `1500 \|\| 0 \|\| 500 \|\| 3000` → 0…3000 | **7** | 1000-1500 ⊃ ancora B (12,3) · **1500 = ancora A (14,9) = la corsa v2** · 1500-2000 ⊃ copia nuda (17,0) |
| **R143c** | U30USD | `1700 \|\| 0 \|\| 500 \|\| 4000` → 0…4000 | **9** | 1500-2000 ⊃ copia nuda · 2500-3000 ⊃ ancora B (27,0) · **3000 ≈ ancora A (31,3) a −4%** |

🔴 **`InpMaxRangePts` e' PINNATO A 0 (tetto SPENTO) in tutti e tre**, e il motivo e'
strutturale: pavimento e tetto agiscono in **versi opposti** sullo stesso `n`, e col
tetto acceso `n(x)` **non e' piu' una curva di sopravvivenza** — i tre simboli non
si confronterebbero. 👉 **Il tetto e' un round SEPARATO (R144), col pavimento
pinnato, e si scrive DOPO, coi numeri di questo.**
📌 **Conseguenza dichiarata**: nessuna cella di R143a/b/c e' il meccanismo `770203`
com'e' in archivio.

---

## 6. 🧪 IL CONTRO-ESEMPIO INCORPORATO — **e dove NON c'e', e' scritto**

| file | ancora di verifica | forza |
|---|---|---|
| **R143b** (D30EUR) | 🟢 **RIPRODUZIONE ESATTA**: la cella `MinRange=0` con `MaxRange=0` **E'** la corsa archiviata di `ABTG_DAX_Live5m` — verificata colonna per colonna (36 input) → **n 225 IS / 342 OOS, PF 0,93488 / 0,85701, DD 26,07% / 39,74%** | **cancello DURO sull'n** |
| **R143a** (NASUSD) | 🟡 **DISUGUAGLIANZA**: `n(1700, tetto spento)` **≥ 116 IS e ≥ 175 OOS** — togliere un filtro puo' solo **aggiungere** giornate | falsificabile, non esatta |
| **R143c** (U30USD) | 🔴 **NESSUNA.** Su U30USD non esiste **nessuna** corsa di questo meccanismo. **Ogni numero e' nuovo.** | eredita R143b |

🔴 **E la regola d'ordine e' scritta dentro i file: se la cella 0 di R143b non
riproduce l'n, NON SI LEGGE NESSUN NUMERO del round — nemmeno di R143a e R143c.**

### 🧪 Ho provato a rompere il cancello duro
Finestra sbagliata, taglio IS/OOS sbagliato, simbolo sbagliato, un input
d'ingresso divergente: **tutti toccano le GIORNATE, quindi l'n, quindi scattano.**
L'unica cosa che passa e' il fix di sizing `3af47ed` (08/08), che tocca il **lotto**
— e puo' toccare l'n **solo** attraverso il clamp di r.1151 (`if(v < mn) v = 0`),
che toglie il deal della parziale e **si diagnostica nel log** (r.1017).
🟢 **Il Guardian e' assolto con una prova positiva**: i CSV archiviati **non hanno
la colonna `InpUsaGuardian`** — verificato su tutti e quattro — quindi il binario
precede `d83c196`; e il pin a `false` e' comunque un **no-op puro**
(`ABTG_PausaGuardian.mqh` r.1600: `if(!attiva) return(true)`).

---

## 7. 💸 IL COSTO, **per gemello, col numero** — e qui c'e' la notizia buona

Spread **MISURATO sui tick BCM nella finestra ESATTA** del round
(`2024.09.26 → 2026.06.30`), **all'ora SERVER giusta per quel simbolo**
(`risultati_archivio/spread_flotta/spread_orario_*.csv`):

| simbolo | ora server | mediana (idx) | P95 | tick |
|---|---:|---:|---:|---:|
| NASUSD | **14** | **1,800** | 2,700 | 10.455.143 |
| U30USD | **14** | **2,000** | 3,000 | 4.931.660 |
| D30EUR | **08** (l'ingresso) | **1,700** | 2,700 | 1.847.049 |
| D30EUR | 🔴 **07** (la candela di trigger) | **2,800** | 4,100 | 746.714 |
| **SPXUSD** | — | 🔴 **`[NON MISURATO]`** | — | — |

### 📊 `stop / spread`, col buffer NUDO (7 idx), come girano i file prova

| | pavimento | stop | **stop/spread** | tetto 40 idx | stop | **stop/spread** |
|---|---:|---:|---:|---:|---:|---:|
| **NASUSD** (riferimento) | 17 | 24,0 | **13,33x** | 40 | 47,0 | 26,11x |
| **D30EUR** @ora 08 | 15 (corsa v2) | 22,0 | 🔴 **12,94x** | 40 | 47,0 | 27,65x |
| **D30EUR** @ora 07 | 15 | 22,0 | 🔴 **7,86x** | — | — | — |
| **U30USD** | 17 | 24,0 | 12,00x | 40 | 47,0 | **23,50x** |

### 🏆 **E IL NUMERO CHE CONTA DAVVERO E' ADIMENSIONALE: lo spread RELATIVO**

| simbolo | spread mediano / prezzo | contro NASUSD |
|---|---:|---:|
| **U30USD** | **0,00374%** | 🟢 **−39,6%** |
| NASUSD | 0,00619% | — |
| D30EUR | 0,00669% | 🔴 **+8,0%** |

> 🔥 **A parita' di stop ESPRESSO IN % DEL PREZZO, il Dow sta a 1,66x il rapporto
> stop/spread del Nasdaq.** Il **13,33x** del Nasdaq diventerebbe **22,1x** sul Dow.
> E detto al contrario, che e' il modo in cui morde:

| per pagare il pavimento di lavoro (stop ≥ 40× spread) serve | stop | = % del prezzo |
|---|---:|---:|
| **U30USD** | 80,0 idx | 🟢 **0,1496%** |
| NASUSD | 72,0 idx | 0,2478% |
| D30EUR | 68,0 idx | 🔴 0,2675% |

👉 **IL DOW CHIEDE UN MOVIMENTO IL 40% PIU' PICCOLO, IN RELATIVO, PER PAGARE LO
STESSO COSTO.** E' il primo simbolo della famiglia in cui il costo **non e'
automaticamente la condanna.**

### 🔴 E ADESSO IL LIMITE, che mi sono costruito da solo
**In R143c il buffer resta NUDO (7 idx), perche' scalarlo sarebbe una SECONDA
variabile.** Quindi la cella piu' alta (40 idx) arriva a **23,50x**, **non** ai 40x.
Il **43,2x** che si ottiene scalando *anche* il buffer (a 12,88 idx) e il cancello
(a 31,3-73,6 idx) e' un **round diverso, a due variabili**, e **non e' questo**.
🚫 **Chi citasse «il Dow passa il pavimento di lavoro» leggendo R143c starebbe
citando un numero che R143c non produce.** La frase vera e' piu' stretta e regge da
sola: **lo spread relativo del Dow e' misurato come il 39,6% piu' basso**, ed e' un
fatto indipendente da qualunque cella.

---

## 8. 🚫 **SPXUSD: NON SI PUO' ANCORA. E serve X.**

| requisito | stato |
|---|---|
| conversione punti | 🟡 `[DERIVATO]` da **2 operazioni** (§1) |
| prezzo mediano | 🟡 da **2 operazioni** (n=2 non e' una mediana, e' un aneddoto) |
| **spread misurato** | 🔴 **ASSENTE.** Non e' in `spread_flotta/` (che copre solo `NASUSD,U30USD,D30EUR`, `RIGA_SPREAD_FLOTTA.ps1` r.86) e non e' in `data/spread_vivo/` (il logger gira su `D30EUR,U30USD,NASUSD,225JPY,EURUSD,GBPUSD,USDJPY` — `ABTG_SpreadLogger.mq5` r.134) |
| ampiezza pre-apertura | 🔴 `[NON MISURATO]` |

🔴 **Senza lo spread il costo NON si calcola.** E il cancello scalato varrebbe
**2,9 – 10,1 punti indice**: una scala in cui uno spread non misurato puo' essere
**un terzo dello stop**. Un file prova su SPXUSD stanotte sarebbe un numero che non
misura il gemello. **Non lo scrivo.**

### 🛠️ LA VIA PIU' CORTA AL NUMERO MANCANTE, con lo script e il costo
| # | cosa | come | costo |
|---|---|---|---|
| 1 | **spread SPXUSD dai tick BCM**, stessa finestra e stesso formato degli altri tre | `backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1 -Simboli "SPXUSD"` — lo script e' **gia' parametrico** sui simboli (r.86) e produce `spread_orario_SPXUSD.csv` identico agli altri | **zero passate di tester.** Durata: gli altri tre hanno letto 250M tick; SPXUSD da solo ≈ **1-2 ore**. 🔴 **Prerequisito NON verificabile da qui: che i tick storici BCM di SPXUSD siano su quel disco.** |
| 2 | **prezzo mediano SPXUSD nella finestra** | esce **gratis** dal punto 1 (lo script legge i tick) **oppure** da `anatomia_aperture.py` sul file M1 SPXUSD, che **c'e'** (2010.11 → 2026.08) | 0 |
| 3 | solo dopo 1 e 2 | si scrive `R143d_preopen_gemello_SPXUSD.txt` sullo stampo di R143c | 18 passate ≈ 1,99 min |

---

## 9. ⏱️ IL COSTO IN TEMPO MACCHINA — `T = 0,6 + 0,077 × passate`

| file | simbolo | celle | passate | **T** |
|---|---|---:|---:|---:|
| `R143a_preopen_metro_NASUSD.txt` | NASUSD | 5 | 10 | **1,37 min** |
| `R143b_preopen_gemello_D30EUR.txt` | D30EUR | 7 | 14 | **1,68 min** |
| `R143c_preopen_gemello_U30USD.txt` | U30USD | 9 | 18 | **1,99 min** |
| **TOTALE in un round unico** | | **21** | **42** | 🟢 **3,83 min** |

📌 Confronto: il piano del 12/09 stimava **3,99 min** per **44 passate** per chiudere
tutto il certificato. Questo round costa **uguale** e chiude **la voce 4 su due
simboli** piu' **la misura della distribuzione** che mancava.

---

## 10. 🚦 CANCELLO — primo strato, lanciato **da solo, mai in pipe**

```
$ python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R143a_preopen_metro_NASUSD.txt
  R143a_preopen_metro_NASUSD.txt   ABTG_Nasdaq_Live5m.mq5     pin=36 celle= 5  OK      EXIT=0
$ ... R143b_preopen_gemello_D30EUR.txt   ABTG_DAX_Live5m.mq5   pin=36 celle= 7  OK      EXIT=0
$ ... R143c_preopen_gemello_U30USD.txt   ABTG_Nasdaq_Live5m.mq5 pin=36 celle= 9  OK     EXIT=0
```
🟢 **3 PASS su 3, exit 0, zero non-ASCII** (verificato byte per byte: 0 byte > 127
in tutti e tre i file). 🔴 **Il SECONDO strato — l'agente `controllo-preventivo` —
NON e' stato lanciato: lo lancia il coordinatore. Finche' non torna, niente esce
verso il VPS.**

### ✅ E le due verifiche sul codice che il dossier chiedeva
- **`ABTG_DAX_Live5m.mq5` espone ESATTAMENTE gli stessi input di
  `ABTG_Nasdaq_Live5m.mq5`**, stessi nomi e stesso ordine. Verificato con un diff
  riga per riga saltando il blocco delle `#define`: **due sole differenze in tutto
  il corpo**, r.619 e r.686, dove cambia la **stringa** passata a
  `ABTG_GuardiaIngresso`. E' **lo stesso motore** (`ABTG_ApertureCore` incluso in
  entrambi). Tutto il resto sta nei default, e ogni default che conta e' **pinnato**.
- **L'ora del DAX e' 08:00 SERVER** (09:00 IT), candela di trigger **07:55-08:00**.
  Doppia conferma in archivio: `studio_apertura.ps1` r.35 (`SH=8`, e il RIEPILOGO
  archiviato porta `apertura;08:00`) **e** il CSV della corsa archiviata di questo
  EA (`InpSessionHour=8`). 🔴 **Un CSV con `InpSessionHour=9` e' in ora italiana e
  si cestina.**

---

## 11. 🕳️ I BUCHI, DICHIARATI PER NOME

| cosa | perche' |
|---|---|
| **ampiezza VERA della candela M5 pre-apertura** | `[NON MISURATO]` su tutti e quattro. La via diretta esiste ed e' **piu' corta**: r.640 stampa `"candela %.0f pt < min %.0f"` per **ogni** giornata scartata → **UNA passata** con `InpMinRangePts` enorme e `InpVerbose=true` stamperebbe l'**intera distribuzione**. 🔴 Ma `walkforward_generico.ps1` raccoglie **solo il log del COMPILATORE** (r.1578-1584), **non** il giornale del tester. Serve una modifica al driver: **dichiarata, non fatta.** |
| **prezzo mediano nella finestra** per D30EUR / U30USD / SPXUSD | l'unico file per-giorno in archivio e' quello del Nasdaq |
| **ancora ATR** | nessuna misura di ATR per simbolo su questa finestra in archivio |
| **spread SPXUSD** | §8 |
| **tick BCM di SPXUSD sul disco del PC di backtest** | non verificabile da qui (e' un disco remoto) |
| **il fattore deal→posizione** | `InpTP1_ClosePct=50` acceso in tutte le celle → `Trades` sono **deal**, fra 1,0x e 2,0x le posizioni (classe 226). Lo chiude **R142a cella 0**, che gira stanotte, non questo round |
| **lato LONG e lato SHORT separati** | girano **insieme** in tutte le celle, come nella corsa archiviata. La regola dei due lati (25/08) e' rispettata nel senso che **tutti e due sono misurati**, ma **non separatamente**. Dichiarato |
| **compilazione dei due EA** | nessun MetaEditor in questo ambiente |

---

## 12. 🪑 E LA COSA DA NON DIMENTICARE

🔴 **Nessuna cella di questo round e' promuovibile**, e il motivo e' un numero, non
una prudenza: per pagare il pavimento di lavoro servirebbe un range di **61,0 idx
(DAX) · 65,0 (Nasdaq) · 73,0 (Dow)** col buffer nudo — **fuori scala per una
candela di cinque minuti**. Il round serve a **chiudere la voce 4 COL NUMERO**,
non a resuscitare il motore.

🟢 **E se esce un altopiano su U30USD, quello e' un fatto nuovo** — perche' il Dow
e' l'unico simbolo in cui il costo relativo non condanna in partenza. In quel caso
si prende **il centro dell'altopiano, mai il picco**, e si porta a Claudio con la
richiesta di una **rigirata a 0,65%** (il PF a 2% **non si trasferisce**:
`ACCOUNT_BALANCE`, capitale composto) e con la **prova di regime**.

---

_Preparato nella notte del 13/09/2026. Nessun backtest eseguito, nessun EA
toccato, nessun preset, `CODA.txt` **intatta**, nessuna sedia promossa, nessun
saldo scritto. Primo strato del cancello: **PASS ×3**. Il secondo lo lancia il
coordinatore._
