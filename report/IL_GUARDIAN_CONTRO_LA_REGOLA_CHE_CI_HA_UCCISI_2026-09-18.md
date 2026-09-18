# 🛡️ IL GUARDIAN CONTRO LA REGOLA CHE CI HA UCCISI — **verifica meccanismo per meccanismo**

**18/09/2026.** Oggi la prop ha chiuso una challenge **in guadagno del 3,26%** con la
regola **giornaliera**. `ABTG_Guardian.mq5` esiste per replicare quella regola e fermarci
prima. Questo referto verifica se il **nostro** conteggio combacia col **loro**.

🔴 **Nessun numero di rischio qui dentro è deciso: sono misure e aritmetica. La firma
resta di Claudio.**
📖 Fonti aperte da me riga per riga: `mql5/Experts/ABTG_Guardian.mq5` (899 righe),
`mql5/Presets/ABTG_Guardian_50504263_779001_VIVO.set`,
`mql5/Presets/ABTG_Guardian_FTMO_2Step.set`, `mql5/Include/ABTG_PausaGuardian.mqh`,
`report/REGOLAMENTI_PROP_2026-09-08.md`, `report/BREACH_FUNDEDNEXT_2026-09-18.md`.

---

## 🥁 LA RISPOSTA CHE CONTA, PRIMA DI TUTTO IL RESTO

> # 🔴 **Col preset VIVO di oggi, su un conto Lite al 4%, il Guardian sarebbe arrivato DOPO la prop. Di 900 dollari.**
> Il blocco duro scatta a **98.358,16** di equity. La prop ha sfondato a **99.258,16**.
> Al momento del breach vero (**99.048,73**) il Guardian era **690,57 dollari** sopra la
> propria soglia: **non avrebbe chiuso niente.**

🟢 **E la buona notizia, che è vera quanto la brutta:** di sette meccanismi, **quattro
combaciano già** — e sono i quattro difficili (equity, riferimento di inizio giornata,
limite in % dell'iniziale, il profitto che allarga la distanza). Quello che non combacia
è **un numero e un'ora**: due input, non un motore da riscrivere. 🔧

---

## 1. 🕐 L'ORA DI RESET — **1 ora di scarto, e si vede in che direzione**

### Il codice, riga per riga
| cosa | dove |
|---|---|
| l'input | `ABTG_Guardian.mq5` **r.133** `input int InpDailyResetHour = 0;` (default = mezzanotte broker) |
| il preset **VIVO** sul 100k | `ABTG_Guardian_50504263_779001_VIVO.set` **r.68** `InpDailyResetHour=23` |
| il preset FTMO | `ABTG_Guardian_FTMO_2Step.set` **r.33** `InpDailyResetHour=23` |
| come si calcola il giorno | **r.199-205** `PropDayKey()`: `shifted = TimeCurrent() - InpDailyResetHour*3600; return DayKey(shifted);` |
| quando scatta il ricalcolo | **r.714-716** (OnTimer) e **r.608** (OnInit) |

### Le due ore affiancate — **1° ottobre 2026** (prima del cambio d'ora del 25/10)

Offset in vigore quel giorno:
- Italia = **CEST = UTC+2**; BCM = italiana − 1 = **UTC+1** — ✅ **MISURATO** il 18/08
  (`report/PIANO_PROP.md` r.1106: Market Watch 19:35:27 con orologio Windows 20:35 nello
  stesso screenshot).
- FundedNext server = **GMT+3 con DST attiva** — ⚠️ **[LETTO-VIA-SEARCH]**,
  `report/REGOLAMENTI_PROP_2026-09-08.md` **r.83** e **r.106**.

| chi | reset nel suo fuso | **in UTC** | in ora server BCM | in ora italiana |
|---|---|---:|---:|---:|
| **FundedNext** | 00:00 GMT+3 | **21:00** | 22:00 | 23:00 |
| **Il nostro Guardian** (`=23`) | 23:00 BCM | **22:00** | 23:00 | 24:00 |

> ### ⏳ **Finestra di disallineamento: 21:00–22:00 UTC. Un'ora piena, TUTTI i giorni.**
> Il nostro giorno parte **un'ora dopo** il loro.
> 🔴 E quella finestra **si apre esattamente sulla chiusura di New York** (17:00 EDT =
> 21:00 UTC) e sul **rollover** di un server UTC+3: il minuto di massimo allargamento
> spread della giornata.

⚠️ **Correzione a un documento di casa.** `REGOLAMENTI_PROP_2026-09-08.md` **r.219** dice
che una perdita in quella fascia *«finisce nel giorno dopo per noi e nel giorno prima per
loro»*. **È invertito.** Verifica aritmetica con `PropDayKey()` (r.201-204): a
`t = 18/09 22:30 BCM`, `shifted = 17/09 23:30` → la nostra chiave è **17/09**, cioè il
giorno **VECCHIO**. La prop ha già girato alle 22:00 BCM: per lei è il giorno **NUOVO**.
👉 **Nella finestra, noi siamo indietro di un giorno, loro avanti.**

### 🧮 ESEMPIO A — due operazioni che la prop mette nello STESSO giorno e noi in DUE
*(la direzione che uccide: noi contiamo MENO di loro)*

Conto 100k Lite, limite prop 4.000. Equity 100.000 al reset prop delle 22:00 BCM del 18/09.

| ora BCM | evento | **conteggio PROP** (giorno iniziato 22:00 del 18/09) | **conteggio GUARDIAN** (giorno iniziato 23:00 del 17/09) |
|---|---|---|---|
| 22:20 del 18/09 | chiusura a **−2.500** → eq 97.500 | perdita **2.500** / 4.000 | perdita 2.500 sul giorno vecchio |
| **23:00 del 18/09** | *il nostro giorno gira* (r.714-721) | — | 🔴 **baseline ri-catturata a 97.500, contatore AZZERATO** |
| 10:00 del 19/09 | chiusura a **−1.800** → eq 95.700 | 100.000 − 95.700 = **4.300 ≥ 4.000 → BREACH** | 97.500 − 95.700 = **1.800 = 1,80%** → sotto pausa 4,0 e sotto blocco 4,9 → **NIENTE** |

> 🔴 **Il punto cieco vale esattamente la perdita fatta dentro la finestra (2.500 dollari).
> La prop se la porta dietro per altre 23 ore; noi la cancelliamo alle 23:00.**

### 🧮 ESEMPIO B — il verso opposto *(costo: operazioni perse, non il conto)*
Stessa giornata, stesse cifre, ore diverse: **−2.500 alle 21:40** e **−1.800 alle 22:30**
BCM. Per la prop sono **due giorni diversi** (2.500 e 1.800: nessun breach). Per noi sono
**lo stesso giorno**: 4.300 = **4,30%** → scatta la **pausa morbida** a 4,0 (r.776-777) e
blocchiamo i nuovi ingressi mentre la prop ha la giornata intera libera.

### 🌗 E IL DST SPOSTA IL NUMERO GIUSTO DURANTE L'ANNO
Formula: `InpDailyResetHour = (offset_BCM − offset_prop) mod 24`.

| periodo | offset BCM | offset FundedNext | valore che fa combaciare |
|---|---|---|---|
| **1/10 → 24/10/2026** | UTC+1 ✅ misurato | UTC+3 ⚠️ letto-via-search | **22** |
| 25/10 → 31/10/2026 | 🕳️ **NON MISURATO** (se BCM segue il DST USA resta UTC+1) | UTC+2 (fine DST europeo) | **23** se BCM resta UTC+1 |
| dal 1/11/2026 | 🕳️ **NON MISURATO** | UTC+2 | **22** se BCM passa a UTC+0 |

⚠️ Il comportamento invernale di BCM è dichiarato **[INCERTO]** già in
`REGOLAMENTI_PROP_2026-09-08.md` **r.238-245** e in `CLAUDE.md`. La misura costa 2 minuti
il lunedì 26/10 (confronto `TimeCurrent()` sul grafico con l'orologio di Windows).
🔴 **Non propongo io il valore da scrivere nel preset: è aritmetica, ma il preset è di Claudio.**

---

## 2. 🎯 LA BASELINE — ✅ **il meccanismo è quello giusto**

| cosa | dove |
|---|---|
| la funzione | **r.235-240** `BaselineGiorno_Calc(bal,eq,modo)`: `if(modo==1) return(bal); if(modo==2) return(MathMax(bal,eq)); return(eq);` |
| la cattura | **r.719-721** (OnTimer) e **r.613-615** (OnInit): `base = BaselineGiorno_Calc(bal,eq,InpDailyBaseline); GlobalVariableSet(GV_DAYSTART,base);` |
| l'uso | **r.733** `double dayStart=GlobalVariableGet(GV_DAYSTART);` · **r.742** `dailyLoss = dayStart - eq;` |
| l'input | **r.147** `input int InpDailyBaseline = 0;` |

### Quale modo riproduce il comportamento della mail?
La mail implica un **riferimento di inizio giornata a 103.258,16**, non il saldo iniziale
di 100.000 (`BREACH_FUNDEDNEXT_2026-09-18.md` r.24). Con una base statica la perdita
sarebbe stata 951, non 4.209.

> ## ✅ **TUTTI E TRE i modi lo riproducono.** La baseline del Guardian **è già** un riferimento di inizio giornata catturato al reset (r.719), **non** il saldo iniziale. Il saldo iniziale (`gStart`) serve solo a calcolare il limite in valuta (r.738), ed è **giusto così**: è esattamente quello che fa FundedNext.

La differenza fra i tre modi è **solo** equity vs saldo vs max, e **conta solo se al
momento del reset c'è una posizione aperta con flottante**. A flottante zero i tre modi
coincidono (lo dice l'autotest stesso, **r.321-323**).

### Il preset vivo quale usa?
🔴 **Non lo imposta.** `ABTG_Guardian_50504263_779001_VIVO.set` elenca gli input alle
**r.64-79** e `InpDailyBaseline` **non c'è**; la **r.22** lo nomina fra i **tre input
MANCANTI dal binario in campo** (16 input nella foto del grafico contro 19 a HEAD, r.19-26).
👉 **Valore effettivo = il default `0` = EQUITÀ** (r.147). E sul binario in campo la
manopola **non esiste proprio**: non è spenta, è assente.

🕳️ **Buco dichiarato:** non sappiamo se FundedNext prenda **saldo** o **equity** di inizio
giornata. `REGOLAMENTI_PROP_2026-09-08.md` **r.81** lo dichiara per FTMO («saldo registrato
alle 00:00»), per FundingPips («il PIÙ ALTO fra saldo ed equity di apertura») e per E8
(«equity O saldo»), ma per **FundedNext dice solo "reset 00:00 server"**. Non è deducibile
dalla mail: se al reset non c'era flottante, i tre modi danno lo stesso numero.

---

## 3. 💰 EQUITY O SALDO — ✅ **COMBACIA**

La mail scrive *«Equity When Account Breached»* (`BREACH_FUNDEDNEXT_2026-09-18.md` r.14):
loro misurano l'**equity**, flottante incluso.

| punto | riga | codice |
|---|---|---|
| lettura | **r.707** | `double eq = AccountInfoDouble(ACCOUNT_EQUITY);` |
| perdita del giorno | **r.742** | `double dailyLoss = dayStart - eq;` |
| DD totale | **r.743** | `totalDD = (InpDDMode==1)? (gPeak-eq) : (gStart-eq);` |
| decisione | **r.750** | `bool breachDaily = (dailyLoss >= dailyLimit);` |

`ACCOUNT_BALANCE` viene letto alla **r.706**, ma **non entra in nessun confronto di
soglia**: serve solo alla baseline in modo 1/2 (r.719), al pannello (r.868) e alla riga di
giornale del credito (r.586-588). ✅ **Nessuna posizione aperta in forte perdita ci passa
sotto il naso: la guardiamo con la stessa lente della prop.**

🟢 Bonus verificato: questo è il **fix v1.12 del 06/09** (r.48-60 dell'intestazione) —
baseline e saldo iniziale presi dall'**equità** proprio per stare sulla stessa base dei
due lati del confronto. Quel lavoro regge.

---

## 4. 📈 IL PROFITTO DELLA GIORNATA ALLARGA IL LIMITE? — ✅ **SÌ, E COMBACIA**

`REGOLAMENTI_PROP_2026-09-08.md` **r.81**, scheda FundedNext:
> *«Il profitto realizzato nella giornata stessa allarga il limite (100k, +2.000 a
> mezzogiorno → limite del giorno 7.000)»*

Il Guardian (**r.738** + **r.742** + **r.750**) sfonda quando
`dayStart − eq ≥ InpDailyLossPct/100 × gStart`, cioè quando
**`eq ≤ dayStart − pct×gStart`**: 👉 **il pavimento è FISSO all'apertura della giornata.**

Riproduzione del loro esempio con la nostra formula:

| | loro | nostro (r.738/742/750) |
|---|---:|---:|
| baseline | 100.000 | `dayStart` = 100.000 |
| pavimento | 95.000 | `100.000 − 5%×100.000` = **95.000** |
| equity a mezzogiorno (+2.000) | 102.000 | 102.000 |
| distanza dal pavimento | **7.000** | `102.000 − 95.000` = **7.000** ✅ |

> ### ✅ **Identico. Non ci fermiamo né troppo presto né troppo tardi su questo meccanismo.**

⚠️ Sfumatura dichiarata: loro dicono *«realizzato»*, noi misuriamo l'**equity** (quindi
anche il flottante alza la distanza). Non è una divergenza: il pavimento è fisso in
entrambi i casi, e la variabile che lo tocca è l'equity da tutte e due le parti (§3).

🕳️ **Il dubbio che NON possiamo chiudere da qui, ed è il più caro.** Un solo dato non
distingue fra due regole:
- **(a)** riferimento = **equity di APERTURA** della giornata → il Guardian combacia;
- **(b)** riferimento = **massimo di equity toccato IN giornata** (high-water mark) → il
  Guardian **sotto-conterebbe sistematicamente dopo una mattina in guadagno**.
Con i numeri della mail le due ipotesi danno **lo stesso 103.258,16** se il conto ha fatto
il massimo all'apertura. 🔎 **Misura che può fare solo Claudio, e costa un minuto**: nella
dashboard FundedNext, il **saldo/equity di APERTURA del 18/09**. Se è 103.258,16 → ipotesi
(a), il Guardian va bene. Se è **più basso** e il conto è salito a 103.258,16 in mattinata
→ ipotesi (b), e allora il nostro meccanismo ha un buco strutturale, non un input sbagliato.
**Questa è la domanda da fargli per prima.**

---

## 5. ⏱️ IL PUNTO PIÙ BASSO TOCCATO — ⚠️ **campioniamo a 1 SECONDO, loro a ogni tick**

| cosa | riga |
|---|---|
| il timer | **r.657** `EventSetTimer(1);` |
| il giro di controllo | **r.704** `void OnTimer()` |
| un giro subito all'avvio | **r.664** `OnTimer();` |
| **nessun `OnTick`** | verificato con `grep -n "OnTick"` su tutto il file: **zero occorrenze** |
| la chiusura | **r.681-701** `FlattenAll()`: giro **sequenziale sincrono**, `gTrade.PositionClose(tk)` una alla volta, **senza retry interno** |
| il ri-tentativo | **r.768-770**: finché è bloccato, `FlattenAll()` viene richiamato **a ogni giro di timer** ✅ |

`REGOLAMENTI_PROP_2026-09-08.md` **r.81** dice che per FTMO conta *«il punto più basso
toccato, anche per una frazione di secondo»*.

### Quanto può durare al massimo un buco di sorveglianza
1. **1 secondo nominale** fra due campioni (r.657). Uno spike che scende sotto il muro e
   risale **dentro lo stesso secondo** è **invisibile a noi e visibile a loro**.
2. **+ il tempo di `FlattenAll`**: N chiusure sincrone in fila (r.685-691), ognuna con il
   suo round-trip al server. Con 5 posizioni e 200-400 ms l'una sono **1-2 secondi in più**
   in cui l'equity continua a muoversi.
3. **+ ritardi di coda**: gli eventi timer MT5 girano sul thread del grafico; un grafico
   carico li accoda.
4. 🔴 **+ infinito** se il Guardian non gira. Il rilevatore c'è (**r.709**, il BATTITO
   `GlobalVariableSet(GV_BATTITO,TimeCurrent())`), ma **rileva, non sostituisce**.

📐 **L'ordine di grandezza, per capire se 1 secondo è tanto**: il cap C1 a 3,25%
(preset r.70) autorizza **3.250 dollari** di rischio aperto simultaneo su 100k. Nel caso
peggiore — un gap che salta tutti gli stop insieme — **un solo secondo copre l'intera
distanza da zero al muro**. Non è un difetto teorico: è la ragione per cui il margine fra
la nostra soglia e la loro non può essere zero.

---

## 6. 🔢 4% CONTRO 5% — **il fatto, senza proposte**

### I fatti, ognuno con la sua fonte
| fatto | fonte |
|---|---|
| **Stellar LITE 100k: limite giornaliero $4.000 = 4,0%** | la mail stessa, `BREACH_FUNDEDNEXT_2026-09-18.md` **r.13** |
| **Stellar 2-Step: 5%** dell'iniziale | `REGOLAMENTI_PROP_2026-09-08.md` **r.81** ⚠️ [LETTO-VIA-SEARCH] |
| FTMO 2-Step: **5%** · FTMO **1-Step: 3%** · E8 One: **3%** · Alpha: **4-5%** | idem **r.81** e **r.255** |
| il nostro blocco duro: **4,9** | `..._VIVO.set` **r.65** e `..._FTMO_2Step.set` **r.21** |
| la nostra pausa morbida: **4,0** | `..._VIVO.set` **r.69** e `..._FTMO_2Step.set` **r.41** |
| il default del codice: **5,0** | `ABTG_Guardian.mq5` **r.130** |

### L'aritmetica, prodotto per prodotto (gStart = 100.000)
Margine di anticipo in dollari = `(muro% − nostro%) × 1.000`.

| prodotto | muro | **4,9 → anticipo del blocco duro** | **4,0 → anticipo della pausa morbida** |
|---|---:|---:|---:|
| FTMO 2-Step / Stellar 2-Step | 5,0% | **+100 $** (arriviamo prima, di un pelo) | +1.000 $ |
| 🔴 **Stellar LITE** (il conto di oggi) | **4,0%** | **−900 $** (arriviamo **DOPO**) | **0 $ esatti** |
| Alpha (variante 4%) | 4,0% | **−900 $** | **0 $** |
| FTMO 1-Step / E8 One | 3,0% | **−1.900 $** | **−1.000 $** |

> ### 🔴 **Su qualunque prodotto con muro ≤ 4,9%, `InpDailyLossPct=4.9` non è una protezione: è una soglia SOPRA il muro. E la pausa a 4,0 su un muro del 4,0% ha margine ZERO — e per di più NON chiude niente (r.776-777: scrive solo una GlobalVariable che blocca i NUOVI ingressi).**

✋ **Non propongo nessun valore.** Il fatto è: *il numero va scelto in funzione del
prodotto comprato, e va scelto sotto il muro con un margine che copra almeno il buco di
campionamento del §5.* **Quanto sotto, è una firma di Claudio.**
💡 Osservazione di struttura, non di numero: oggi il preset è **unico** per prodotti con
muri diversi. Un `.set` per prodotto (col muro scritto nel commento) toglie l'errore di
classe, qualunque numero si scelga.

---

## 7. 🧪 L'AUTOTEST A 22 CASI — **NON copre il caso di oggi**

Contati da me uno per uno in `ABTG_Guardian.mq5` **r.269-345** (`AutotestBaselineGiorno()`),
marcatore alla **r.339** (`"TUTTI I 22 CASI PASSATI"`):

| gruppo | righe | casi | cosa prova |
|---|---|---:|---|
| A | 273-283 | 5 | flottante negativo al reset (bal 100.000 / eq 99.200) + i due pavimenti al 5% |
| B | 287-292 | 3 | flottante positivo (bal 100.000 / eq **100.500**) |
| C | 297-307 | 4 | conto reale col credito (5.000 / 7.500) |
| D | 310-313 | 2 | input fuori scala → ripiego |
| E | 316-323 | 3 | invarianti fra i modi |
| F | 326-337 | 5 | i testi del modo nel giornale |
| | | **22** | |

### 🔴 Cosa NON copre, e sono esattamente le quattro cose che sono costate oggi
1. **Una baseline SOPRA il saldo iniziale con profitto in giornata.** La baseline più alta
   provata è **100.500** (gruppo B, r.287): **+0,5%**. Quella di oggi era **103.258,16**:
   **+3,26%**, sei volte tanto.
2. **L'aritmetica della soglia** `dailyLimit = pct × gStart` (**r.738**) quando
   `dayStart ≠ gStart`. Nessun caso la tocca: l'autotest collauda `BaselineGiorno_Calc` e
   basta, cioè **da dove parte il conteggio, mai dove finisce**.
3. **La decisione** `breachDaily = (dailyLoss >= dailyLimit)` (**r.750**): 🔴 è scritta
   **in linea dentro `OnTimer`**, **non è una funzione pura** e **nessun autotest la
   raggiunge** — né i 22 del Guardian né i 159 dell'include
   (`ABTG_PausaGuardian.mqh` r.2448).
4. **`PropDayKey()`** (r.199-205): stessa cosa, non pura (legge `TimeCurrent()` e l'input)
   e non collaudata. L'include ha un test analogo per **un'altra** funzione,
   `ABTG_InizioGiornoServer_Calc` (r.1944-1949) — **due implementazioni diverse dello
   stesso concetto**, e solo una collaudata.

> ### ✅ **Sì: il caso del breach di oggi va aggiunto.** L'ho scritto coi numeri veri della mail — sta in `report/PATCH_PROPOSTA_GUARDIAN_2026-09-18.md`, **NON applicato al codice.**

---

## 🎯 IL CONTRO-ESEMPIO OBBLIGATORIO — **la giornata del 18/09 rigiocata col nostro Guardian**

**Ingredienti** (tutti misurati, nessuno stimato): baseline **103.258,16** ·
equity minima **99.048,73** · limite prop **4.000,00** · `InpStartBalance=100000`
(preset r.64) · `InpDailyLossPct=4.9` (r.65) · `InpDailyPausePct=4.0` (r.69).

**Le formule usate** (non parafrasate — sono le righe):
`dailyLimit = InpDailyLossPct/100 × gStart` (r.738) · `dailyLoss = dayStart − eq` (r.742) ·
`dailyPct = 100×dailyLoss/gStart` (r.745) · `breachDaily = dailyLoss ≥ dailyLimit` (r.750) ·
pausa: `dailyPct ≥ InpDailyPausePct` (r.776).

| chi | soglia in % | **perdita che la fa scattare** | **equity a cui scatta** | cosa fa |
|---|---:|---:|---:|---|
| 🏦 **la PROP (Lite 4%)** | 4,0% | **4.000,00** | **99.258,16** | chiude il conto |
| ⏸️ Guardian — **pausa morbida** | 4,0% | 4.000,00 | **99.258,16** | 🔴 **NON chiude**: scrive solo la GV che blocca i **nuovi** ingressi (r.776-777) |
| 🛑 Guardian — **blocco duro** | 4,9% | **4.900,00** | **98.358,16** | `FlattenAll()` + blocco per la giornata (r.759-765) |
| 📌 **il breach vero** | 4,209% | 4.209,43 | 99.048,73 | — |

### 👉 CHI SCATTA PER PRIMO
> # 🔴 **LA PROP.**
> Il nostro blocco duro sta **900,00 dollari SOTTO** il loro muro. Al momento del breach
> (equity 99.048,73) mancavano ancora **690,57 dollari** perché il Guardian chiudesse.
> La pausa morbida sarebbe scattata **nello stesso identico istante** del breach — margine
> **0,00** — **e non avrebbe chiuso la posizione aperta**: blocca solo i nuovi ingressi.

> ### 🔴 **Verdetto: sul conto di oggi il Guardian non avrebbe cambiato NIENTE. Nemmeno attaccato, nemmeno perfettamente funzionante.**
> *(E infatti non era attaccato: `BREACH_FUNDEDNEXT_2026-09-18.md` §5 — zero occorrenze
> del conto `12061434` in tutto il repo. Ma questo referto dice una cosa peggiore: **anche
> se ci fosse stato, sarebbe stato inutile.**)*

### 🧪 L'IPOTESI ALTERNATIVA, che è la parte che rende il conto una misura
Se il prodotto fosse stato lo **Stellar 2-Step al 5%** — cioè quello che il nostro dossier
aveva censito (r.81) e su cui il 4,9 è stato tarato:

| chi | perdita di scatto | equity |
|---|---:|---:|
| la prop (5%) | 5.000,00 | **98.258,16** |
| Guardian blocco duro (4,9%) | 4.900,00 | **98.358,16** |

> ✅ **Lì il Guardian scatta PRIMO, di 100,00 dollari.** Il verso della risposta **si
> capovolge col prodotto**. 👉 Quindi il difetto non è "il Guardian è rotto": è che **la
> taratura è legata a un prodotto e il preset non lo dichiara**. E 100 dollari di margine
> vanno letti accanto al §5: **un secondo di campionamento su 3.250 dollari di rischio
> aperto autorizzato.**

---

## 📋 COSA COMBACIA / COSA NO

| # | meccanismo | **FundedNext** | **ABTG_Guardian** (riga) | esito |
|---|---|---|---|:--:|
| 1 | variabile misurata | **EQUITY** (mail: *"Equity When Account Breached"*) | `ACCOUNT_EQUITY` r.707 → r.742/743/750 | ✅ |
| 2 | riferimento del giorno | inizio giornata (103.258,16), **non** l'iniziale | `dayStart` catturata al cambio giorno r.719-721, letta r.733 | ✅ |
| 3 | limite in valuta | **% dell'INIZIALE** (4.000 su 100k) | `pct × gStart` r.738, `gStart`=100.000 da preset r.64 | ✅ meccanismo |
| 4 | il profitto allarga la distanza | sì (100k, +2.000 → 7.000) | pavimento fisso `dayStart − pct×gStart` → distanza 7.000 ✅ | ✅ |
| 5 | azione al superamento | chiude il conto | `FlattenAll()` r.681 con `InpAction=0` (preset r.73) | ✅ |
| 6 | 🔴 **valore della soglia** | **4,0%** (Lite) | **4,9%** blocco · 4,0% pausa (preset r.65/69) | 🔴 **NO — sopra il muro** |
| 7 | 🔴 **ora di reset** | 00:00 GMT+3 = **21:00 UTC** | 23:00 BCM = **22:00 UTC** (preset r.68) | 🔴 **NO — 1 ora** |
| 8 | ⚠️ **granularità** | ogni tick, "anche una frazione di secondo" | `EventSetTimer(1)` r.657, **nessun `OnTick`** | ⚠️ **1 s + tempo di chiusura** |
| 9 | baseline: saldo o equity? | **non dichiarato** per FundedNext (regolamenti r.81) | modo **0 = EQUITÀ** (default r.147, non nel preset) | 🕳️ **non verificabile** |
| 10 | riferimento = apertura o massimo del giorno? | **[NON MISURATO]** — la mail non distingue | apertura (r.719) | 🕳️ **il dubbio più caro (§4)** |
| 11 | pausa morbida | non esiste il concetto | non chiude, blocca solo i nuovi ingressi (r.776-777) | ⚠️ **non è una rete** |

---

## 🕳️ BUCHI DICHIARATI — quello che questo referto NON ha misurato

1. 🔴 **Le regole dello Stellar Lite non sono state lette alla fonte.** Il 4% viene dalla
   **mail di breach** (fonte primaria per l'importo, **non** per la regola). Le pagine dei
   prop rispondono **403** al nostro proxy (`REGOLAMENTI_PROP_2026-09-08.md` r.43).
2. 🔴 **Apertura o massimo del giorno** come riferimento FundedNext: §4. **Un solo dato non
   distingue le due ipotesi.** È la misura più importante da chiedere a Claudio.
3. ⚠️ **Il fuso di FundedNext (GMT+3) è [LETTO-VIA-SEARCH]** (regolamenti r.83/r.106), mai
   confermato per iscritto dal supporto.
4. 🕳️ **Il comportamento invernale di BCM non è misurato** (r.238-245 dei regolamenti):
   dal 25/10 il valore che fa combaciare l'ora **cambia**, e non sappiamo di quanto.
5. 🔴 **Il binario in campo è più vecchio del sorgente**: `..._VIVO.set` r.19-26, **16
   input contro 19**. Tutto questo referto legge **HEAD**; il Guardian attaccato al 100k
   `50504263` è un altro compilato. **Non ho verificato oggi quale binario giri davvero.**
6. 🔴 **Sul piccolo `50503392` nessun Guardian gira** (CLAUDE.md, giornale 11-12/09) e
   `ABTG_EMA200` in campo non legge il canale. Fuori dal perimetro di oggi, ma **è la
   stessa famiglia di difetto: una rete che non è dove serve.**
7. 🕳️ **Due fail-open trovati leggendo, non richiesti dalle sette domande** — li segnalo
   perché entrambi riguardano il conteggio giornaliero:
   - **r.714-716**: `if((int)GlobalVariableGet(GV_DAYKEY)!=pk)`. Se le GlobalVariable
     spariscono **a metà giornata** (terminale nuovo, cartella dati diversa, pulizia da
     F3, `GlobalVariablesDeleteAll`), `GlobalVariableGet` torna **0**, la condizione è vera
     e la **baseline viene ri-catturata all'equity corrente**: 🔴 **la perdita del giorno
     si azzera in silenzio.** Non c'è nessuna riga che distingua "giorno nuovo" da
     "variabile persa".
   - **r.572-573**: con `InpStartBalance=0`, `gStart` = **equity del primo avvio**. Un
     Guardian attaccato a challenge già avviata con equity 103.258 calcolerebbe il limite
     su **103.258**, non su 100.000 (a 4,9% sono **5.060** invece di 4.900). Il preset vivo
     mette 100000 esplicito (r.64) e quindi **oggi è coperto** — ma per preset, non per
     codice.
8. ⚠️ **`PropDayKey()` (r.201) non protegge l'input** come fa `NextResetTime()` (r.215,
   `if(h<0) h=0; if(h>23) h=23;`). Con un `InpDailyResetHour` fuori scala le due funzioni
   **divergono**: il giorno gira a un'ora e la scadenza della pausa a un'altra.

---

## ✅ COSA HO CONTROLLATO E COME (Agente dei Controlli)

- 🧮 **Contro-esempio costruito, non solo la conferma**: l'ipotesi alternativa del §"contro-
  esempio" (prodotto al 5% invece del 4%) **capovolge il verdetto** — quindi la misura
  distingue davvero i due casi e non è un numero che torna per caso.
- 🔢 **Aritmetica del reset verificata rigirando `PropDayKey()` a mano** su due istanti
  (22:30 e 23:30 BCM): ha trovato **un'inversione in un documento di casa**
  (`REGOLAMENTI_PROP_2026-09-08.md` r.219), segnalata al §1.
- 📏 **I 22 casi contati uno per uno** (5+3+4+2+3+5), non presi dalla stringa della r.339.
- 🔎 **`grep` su `OnTick`**: zero occorrenze — la frequenza del §5 è letta, non assunta.
- ✋ **Nessun file in campo toccato**: `coda/CODA.txt` intatto, nessun EA modificato,
  nessun preset modificato. La proposta di codice sta in un file **separato**.

---

*Referto scritto il 18/09/2026. Nessun parametro di rischio è stato deciso qui dentro:
il §6, il §1 e il §"contro-esempio" quantificano, la firma è di Claudio.*
