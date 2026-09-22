# 🪑 CHI ALTRO PUÒ SCHIERARSI — la lista corta, coi numeri e con quello che manca

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA.** Nessun round lanciato, nessuna riga
consegnata, niente sul VPS, niente sul forward, **nessun preset toccato**, nessun candidato
promosso e nessuno archiviato d'autorità. **Porto la lista e i numeri: decide Claudio.**

> 🎯 **LA DOMANDA**: la challenge FTMO è viva da ieri con sei sedie. Mancano **nove giorni**
> al 1° ottobre. **Chi altro, in casa, è abbastanza vicino da meritare una sedia?**

---

## 🔟 LA RISPOSTA IN SEI RIGHE

1. 🎯 **Ho rimacinato 2.418 CSV** con lo script di casa (`censimento_pf.py`, ricorso stanotte)
   e ho applicato i cancelli in blocco: PF ≥ 1,10 **in tutte e due le finestre**, n OOS ≥ 150,
   `Equity DD %` < 10% in tutte e due, **escluse le corse OHLC**. Passano **31 righe**, e
   **30 su 31 sono configurazioni delle sei sedie già in campo**.
   🔥 **La trentunesima NO, ed è la notizia di questo referto.**
2. 🥇 **IL CANDIDATO È IL DOW D'APERTURA IN VERSIONE *BREAKOUT A DUE LATI*, range 15'**
   (magic `770201`) — **un altro motore** dalla sedia `770202` che vola (retest, solo long,
   range 35': **dodici input differiscono**). A tick reali, walk-forward vero:
   **OOS 40 celle su 40 in utile, PF 1,267–1,560 (mediana 1,37264), DD massimo 8,70%,
   n 188 POSIZIONI** — e in IS 38/40 sopra 1,10. 🔴 **Il suo difetto è UNO solo e l'ho
   trovato io: la finestra IS parte dal 2024.01.01, cioè PRIMA del pavimento dei tick BCM
   sugli indici (2024.09.26, classe 590).** §2.1.
3. 🥈 **Dietro di lui, `ABTG_ORB_Ottimizzato` U30USD LONG**, già in lavorazione
   (`R211a`/`R211b`): **PF OOS 1,65693–1,95461 · n 119 · DD 9,92–11,04% @1%**. Gli manca
   **il campione (119 < 150)** e **il DD alla taglia vera**. 🔴 E stanotte gli ho chiuso una
   via d'uscita: *«aggiungo il lato corto e arrivo a 150»* **non funziona**, ed è misurato —
   `R54b` dà short PF **0,5197** con DD **26,37%**, e due-lati PF **1,0475** con DD **17,16%**
   su n 219. §2.2.
4. 🔥 **E la seconda cosa nuova: `ABTG_EMA200` H4 sul forex A DUE LATI è stata letta male,
   e il numero giusto è il doppio.** I dossier di settembre leggevano le celle a **un lato
   solo** (138-200 deal) e concludevano *«fuori per aritmetica del campione»*. Le celle a
   **DUE lati**, nello stesso identico file, fanno **187-362 deal**: `GBPUSD` **362** ·
   `AUDJPY` **265** · `GBPJPY` **221** · `XAUUSD` **187**, con PF mediano **1,231 / 1,514 /
   1,240 / 1,381** e DD **4,42-7,21%** a tick reali. 🔴 **Ma NON hanno un OOS**: finestra
   unica e ottimizzatore **GENETICO** — quindi quei PF sono in-campione per costruzione.
   §2.3.
5. 🟢 **E la frequenza NON è più il loro ostacolo.** Firma del 07/09: il pavimento di 1,00
   op/giorno è **per FAMIGLIA**. La famiglia `EMA200` il pavimento **lo tocca già** con la
   sedia Dow `771531` (1,000 pos/g misurate in forward). 👉 Le esclusioni dei gemelli H4
   motivate **solo** dalla frequenza **vanno rilette** — ed è esattamente il caso.
6. 🪦 **E ho chiuso col numero cinque strade che in repo sembravano ancora aperte**: il
   gemello Apertura sul **CAC** (`R138a` è GIRATO: **PF OOS 0,76965**, mai letto da nessuno),
   il **Live5m** su Nasdaq e DAX (a tick fa **0,96 / 0,92 / 0,86**, non il 2,16 del CSV OHLC),
   il **MaxMinNotte** sugli altri indici, l'**ORB sul Nasdaq**, il **CostToCost**. §4.

---

# 📊 §1 · LA TABELLA — ordinata per QUANTO È VICINA A SCHIERARSI, non per PF

**Legenda dello stato:** 🟡 = candidata viva, ferma per un numero **mancante** ·
🪦 = archiviabile, ferma per un numero **brutto** (il numero è scritto).

🔴 **Tutti i `DD` di questa tabella sono al rischio dichiarato nella colonna, NON al 2,00%
dei preset FTMO.** Classe 547: per confrontarli col muro del 10% vanno **riscalati alla
taglia vera**, e il riscalamento è una **derivazione**, non una misura (il lotto si calcola
su `ACCOUNT_BALANCE`, cioè a capitale composto: raddoppiare il rischio non raddoppia
esattamente il DD). Dove lo scrivo, lo scrivo come stima e lo dichiaro.

| # | candidato | simbolo / TF | PF OOS | n OOS | DD OOS | frequenza | cosa MANCA | costo per chiuderlo |
|---|---|---|---|---|---|---|---|---|
| **1** 🟡 | 🔥 **Motore APERTURA US in versione *BREAKOUT A DUE LATI*, range 15'** (magic `770201`) — **non è la sedia `770202`** | `U30USD` M5 | **1,26748 – 1,55976** · mediana **1,37264** · 🟢 **40 celle su 40 ≥ 1,10** | **188 POSIZIONI** 🟢 *(`InpTP1_ClosePct=0` ⇒ niente parziale ⇒ deal = posizioni)* · IS 140 | **4,4071%** mediana · 🟢 **max 8,6965%** su 40 celle | 🟢 **0,720 pos/g** — la più alta della lista | 🔴 **L'IS parte dal 2024.01.01, PRIMA del pavimento tick 2024.09.26 (classe 590)**: ~9 mesi su 18 sono tick **generati** · **DD alla taglia FTMO** · **sovrapposizione con `770202`** (stesso indice, stessa apertura) mai misurata | **40 celle × 2 finestre = 80 passate ≈ 6,8 min**, rigirando l'IS da `2024.09.26` |
| **2** 🟡 | **`ABTG_ORB_Ottimizzato`** LONG *(già in lavorazione)* | `U30USD` M5 | **1,65693 – 1,95461** (med. 1,736) | **119 posizioni** (IS 71) | **9,92 – 11,04%** @1% | **0,449 pos/g** (fam. ORB da sola) | **campione** 71/119 ≪ 150 · **DD alla taglia FTMO** (≈ 19,8-22,1% @2%, *stima*) · l'asse `InpTPRangeMult` **è al bordo**: il PF OOS sale monotono fino a 3,0, la griglia non è chiusa | `R211a` **già scritto** (8 passate ≈ 1,2 min); + estensione asse 3,5/4,0 = **4 passate** |
| **3** 🟡 | **`ABTG_ORB_Ottimizzato`** — **gemello DAX mai provato** | `D30EUR` M5 | **[NON MISURATO]** | — | — | — | **tutto**: il simbolo non è mai stato girato con questo motore | `R211b` **già scritto**, mai eseguito |
| **4** 🟡 | **`ABTG_EMA200` H4 DUE LATI** | `GBPUSD` H4 | **[NON MISURATO]** · finestra unica **1,231** (24/24 celle ≥1,10) | **362 deal** ≈ **180 posizioni** *(derivate)* | **7,205%** @1% (banda 5,78-9,22) | **0,276 pos/g** · 🟢 **famiglia EMA200 già a 1,00** | **lo split IS/OOS** (oggi è **una finestra sola**) · **ottimizzazione NON genetica** (oggi `Optimization=2`: le celle sono selezionate, il «24/24» è selezione, non altopiano) · **n in POSIZIONI** (derivato dal rapporto 2,0117 misurato su U30USD) | **24 celle × 2 finestre = 48 passate ≈ 4,3 min** |
| **5** 🟡 | **`ABTG_EMA200` H4 DUE LATI** | `AUDJPY` H4 | **[NON MISURATO]** · finestra unica **1,514** (27/28) | **265 deal** ≈ **132 pos.** | **6,261%** @1% (2,89-9,46) | **0,202 pos/g** | come sopra **+** 🔴 **costo R5 `[NON MISURATO]`**: alla sonda del 17/08 `AUDJPY` legge `SpreadPt=0` = *nessun tick*, non spread nullo | **56 passate ≈ 4,9 min** + 1 sonda spread |
| **6** 🟡 | **`ABTG_EMA200` H4 DUE LATI** | `GBPJPY` H4 | **[NON MISURATO]** · finestra unica **1,240** (15/19) | **221 deal** ≈ **110 pos.** | **4,422%** @1% (3,79-7,03) | **0,169 pos/g** | come #4 (costo `GBPJPY` derivato: **0,8645 pip**) | **38 passate ≈ 3,5 min** |
| **7** 🟡 | **`ABTG_EMA200` H4 DUE LATI** | `XAUUSD` H4 | **[NON MISURATO]** · finestra unica **1,381** (25/29) | **187 deal** ≈ **93 pos.** | **6,145%** @1% (5,08-8,32) | **0,143 pos/g** | come #3 **+** l'oro è **già occupato** dalla sedia `770402` → va misurata la **sovrapposizione**, non solo il PF | **58 passate ≈ 5,1 min** |
| **8** 🟡 | **`ABTG_HVAncora`** | `U30USD` | **1,03844** (miglior cella **1,92073**) | **35** (IS 22-37) | **3,841%** — 🟢 il più basso della lista | **[NON MISURATO]** | **il campione, e il tappo è a monte e misurato**: **91 ancore IS e 165 OOS SCADONO** prima di diventare operazioni. Non è una manopola: è il meccanismo | **[NON STIMATO]** — prima va deciso se si tocca la scadenza dell'ancora |
| **9** 🪦 | **`ABTG_SuperWave`** *(nativo)* | `GBPUSD` **H2** | **2,0861** (IS 1,7217) | **63** (IS 28) | **2,126%** @1% | 0,238 deal/g | 🔴 **niente: il numero c'è ed è un PICCO.** Sullo stesso file i vicini in IS sono **rossi**: H1 **0,703** · H3 **0,807** · H4 **0,153**. E dove il campione esiste (M15 n=360, M30 n=229, M20 n=298) il PF OOS è **0,72 / 0,77 / 1,00** | — |
| **10** 🪦 | **`ABTG_CostToCost`** | `EURJPY` H4 | **1,52341** | **242** (IS 153) | 🔴 **12,2627%** @1% — **e IS 10,99%** | — | 🔴 **RISCHIO: sopra il 10% in TUTTE E DUE le finestre a rischio 1%.** E su OHLC il DD è un **limite inferiore** → a tick può solo peggiorare | — |
| **11** 🪦 | **`ABTG_IntradayMomentum`** | `NASUSD` M30 | **1,2433** (cella 2ª: 1,4861) | **261** | **3,030%** @**0,65%** | — | 🔴 **RISCHIO IS: DD 7,763% a rischio 0,65%** (≈ 23,9% @2%, *stima*) · e **MERITO IS negativo su un campione quasi giudicabile: PF 0,5994 con n = 146**. Il segno si ribalta su **4 celle su 4** e su **due simboli su due** | — |
| **12** 🪦 | **`ABTG_ORB_Ottimizzato`** | `NASUSD` M5 | 1,0806 – 1,1556 | 135 | 🔴 **12,26 – 20,63%**; **IS 19,71 – 23,86%** | — | 🔴 **RISCHIO**, e il fatto è accaduto: DD IS quasi **24%** a rischio **1%** | — |
| **13** 🪦 | **`ABTG_ORB_Ottimizzato`** SHORT / DUE LATI | `U30USD` M5 | **0,5197** (short) · **1,0475** (due lati) | 100 · **219** | 🔴 **26,370%** · **17,162%** | — | 🔴 **È la via ai 150 che NON esiste**: i due lati **superano** il pavimento (219) ma sfondano PF **e** DD | — |
| **14** 🪦 | **`ABTG_Nasdaq_Live5m`** | `NASUSD` M5 | 🔴 **0,96265** *a tick reali* | 175 | 🔴 **19,4006%** @**2%** | — | 🔴 Niente. **Il PF 2,16 del censimento è un artefatto OHLC**: stessi identici 65 input, stessa finestra, e a tick il profitto passa da **+8.943,56** a **−326,54** | — |
| **15** 🪦 | **`ABTG_DAX_Live5m_v2`** / **`_v1`** | `D30EUR` M5 | 🔴 **0,92490** / **0,85701** *a tick* | 202 / 342 | 🔴 **14,159%** / **39,744%** | — | 🔴 Niente. Idem: in OHLC facevano 1,71 e 1,47 | — |
| **16** 🪦 | **`ABTG_DAX_Apertura_EU`** — **gemello CAC** | `F40EUR` M5 | 🔴 **0,76965** | 195 | 🔴 **11,8210%** @1% | — | 🔴 Niente — **e nessuno l'aveva letto**: `R138a` è **girato**, profitto **−7.266,30**. E lo **studio FASE A** lo prevedeva: aspettativa a rottura cieca **−0,056 R** sul CAC | — |
| **17** 🪦 | **`ABTG_MaxMinNotte`** — gemelli indici | `F40EUR` · `E50EUR` · `100GBP` | 🔴 **max 0,999 / 0,840 / 0,672** su 54 celle ciascuno | 80-195 | 17,7 / 33,3 / 46,4% (mediane) | — | 🔴 Niente: **nessuna cella arriva a 1,00**, figurarsi a 1,10 | — |

---

# 🔬 §2 · I QUATTRO CANDIDATI VIVI, uno per uno — **col contro-esempio costruito da me**

## 🥇 §2.1 · IL DOW D'APERTURA IN VERSIONE **BREAKOUT A DUE LATI** — il candidato numero uno

🔴 **Prima di tutto, che cos'è e che cosa NON è.** **Non** è la sedia `770202` che vola, e
**non** è una sua cella migliore. È **un'altra configurazione dello stesso sorgente**: il
`REGISTRO_TEST.md` (12/09) ha già fatto il diff manopola per manopola e conta **DODICI input
diversi** — `InpEntryMode` **0 (BREAKOUT)** contro **2 (RETEST)** · `InpRangeMinutes` **15**
contro **35** · `InpBufferPoints` **200** contro **1000** · `InpAllowShort` **1** contro
**false** · `InpTP1_ClosePct` **0** contro **50** · magic **770201** contro **770202**.
👉 **È un'altra sedia** — ed è esattamente per questo che qui è un **candidato**, non un
doppione (classe 224, disinnescata: lì si diceva *«non usare questo numero PER `770202`»*, e
resta vero; qui il numero si usa **per sé stesso**).

**Fonte:** `backtest_pipeline/risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv`
(40 celle vive per finestra, **tick reali**, deposito 10.000, rischio 1%,
`InpSessionHour=14` ✅ ora server BCM). Griglia **vera a due assi**: `InpEmaSlow` 20…200 ×
`InpTP1_R` 0,33/0,50/0,67/0,84.
**Finestre dichiarate nello script:** IS `2024.01.01→2025.06.30` · OOS `2025.07.01→2026.06.30`.

| | celle in utile | celle ≥ 1,10 | PF (banda) | PF mediano | DD massimo | n mediano |
|---|--:|--:|---|--:|--:|--:|
| **IS** | 39 / 40 | **38 / 40** | 0,988 → 1,546 | **1,27610** | 12,4677% | **140** |
| **OOS** | 🟢 **40 / 40** | 🟢 **40 / 40** | **1,267 → 1,560** | **1,37264** | 🟢 **8,6965%** | **188** |

🟢 **Perché è in cima**: è **l'unica riga non schierata**, in tutto l'archivio, che passa
**tutti e quattro i cancelli sull'OOS insieme** — PF 1,37 ≥ 1,10 · n **188 ≥ 150** ·
DD 4,41% (e **massimo 8,70% su quaranta celle**) < 10% · e **tutti e due i lati accesi**
(`InpAllowLong=1` **e** `InpAllowShort=1`), quindi la regola del 25/08 è soddisfatta **per
costruzione**, non per deroga.
🟢 **E i 188 sono POSIZIONI, non deal**: `InpTP1_ClosePct=0` ⇒ nessuna chiusura parziale ⇒
un ingresso = un'uscita. 👉 **La classe 550 qui non morde, ed è verificato nel CSV**, non
assunto.

### 🧪 IL CONTRO-ESEMPIO — **ne ho costruiti cinque. Quattro mordono, e il primo è mio.**

1. 🔴 **«La finestra è di 30 mesi.» ❌ NO: metà dell'IS non ha i tick, e LA PROVA È
   NELL'ANOMALIA CHE IL DOCUMENTO DI CASA AVEVA LASCIATO APERTA.**
   `DOW_MOTORE.md` r.406-416 segnala: *«IS 146 trade in 18 mesi = **8,1/mese**; OOS 197 in 12
   = **16,4/mese**. Il doppio. O il filtro EMA ha bloccato di più nel 2024, oppure lo storico
   di U30USD non copre davvero l'inizio del 2024. **Va verificato.**»*
   🟢 **L'ho verificato, e la seconda spiegazione torna al 2,3%.** I tick BCM sugli indici
   partono dal **2024.09.26** (classe 590). Da lì al 30/06/2025 ci sono **9,1 mesi**, non 18:

   | | trade | mesi **dichiarati** | trade/mese | mesi **con tick veri** | trade/mese **veri** |
   |---|--:|--:|--:|--:|--:|
   | IS | 146 | 18 | 8,11 | **9,1** | **16,04** |
   | OOS | 197 | 12 | **16,42** | 12 | 16,42 |

   👉 **16,04 contro 16,42: lo scarto crolla da 2,03× a 1,02×.** Il filtro EMA è **assolto**,
   e l'IS **è vero ma è lungo la metà di quanto dichiarato**. 🔴 **Conseguenza pratica: l'IS
   va rigirato da `2024.09.26`**, altrimenti il tester ha lavorato su ~9 mesi di tick
   **generati dalle M1**, che è screening, non verdetto.
2. 🔴 **«Il 40/40 dimostra un altopiano.» ⚠️ Dimostra il contrario di quello che sembra, e lo
   dice il file stesso: la correlazione di rango IS→OOS è −0,357, NEGATIVA.** Le cinque celle
   migliori in IS si piazzano **31ª, 23ª, 21ª, 35ª, 24ª su 40** in OOS.
   👉 **Su questi due assi NON si ottimizza**: la classifica dentro la griglia è rumore.
   🟢 **Ma è una buona notizia travestita**: se *tutte* e 40 passano e la posizione esatta non
   conta, **l'edge sta nel MOTORE e non nella taratura** — che è l'opposto del sovradattamento.
   🔴 E va detta la conseguenza scomoda: **la cella da schierare va scelta al CENTRO
   dichiarato, mai col picco**, e `InpEmaSlow=50` (quello che l'EA usa) **non era nella
   griglia** (andava di 20 in 20): sta fra 40 (PF OOS 1,340) e 60 (1,358), **ed è quindi un
   valore mai misurato**.
3. 🔴 **«Il DD è sotto il muro.» ⚠️ A rischio 1%.** Alla taglia FTMO del 2,00%: mediana
   ≈ **8,8%**, massimo di griglia ≈ **17,4%** *(stima, non misura)*. 👉 **La mediana resta
   dentro il muro, il peggio della griglia no.** Classe 562: sotto soglia **dimostra**, sopra
   **non conclude** — quindi la riga onesta è *«la cella centrale è dimostrabilmente sicura
   solo dopo una passata alla taglia vera»*.
4. 🔴 **«È diversificazione.» ❌ NO: è lo STESSO indice e la STESSA apertura della sedia
   `770202` già in campo.** Due sedie sull'apertura del Dow alle 14:30 server sono **due
   scommesse sullo stesso evento**, anche se una compra la rottura e l'altra il ritest.
   👉 Va misurata la **sovrapposizione dei giorni operativi** prima di qualunque firma —
   strumenti già in casa: `sovrapposizione_sedie.py`, `chi_va_con_chi.py`. **Non l'ho fatta.**
   ⚠️ E tocca il **cluster `AZIONARIO`**: con `770101`, `770202`, `770260`, `770511` e questa,
   si arriva alla **quinta sedia sullo stesso cluster** — che è esattamente il punto in cui
   `CLAUDE.md` dice che il tetto C2 *«diventa una rete»*.
5. 🟢 **«È una passata sola?» ❌ No, e qui il candidato regge bene**: sono **40 celle × 2
   finestre = 80 passate**, e `DOW_MOTORE.md` dichiara **186 passate a tick reali** in tutto
   sul motore (fase motore + robustezza + distanze + trailing + walk-forward).

### ⚠️ E UNA COSA DA VERIFICARE PRIMA DI TOCCARE QUALSIASI COSA
`DOW_MOTORE.md` r.3 dichiara che il motore girato è **`ABTG_Nasdaq_Apertura_US` applicato a
U30USD**, non `ABTG_Dow_Apertura_US`. 🔴 **Quale sorgente compilare non è quindi ovvio**, e
sbagliarlo vorrebbe dire schierare un motore diverso da quello misurato (è l'errore che la
classe 224 ha già costato una volta). **Il diff dei due sorgenti non l'ho fatto: `[NON
VERIFICATO]`.** È la prima cosa da chiudere, e costa una lettura, non una corsa.

### ➡️ La via più corta al numero, e quanto costa
**Un round solo, la stessa griglia, con l'IS onesto**: `@DAQUANDO 2024.09.26` +
`@FRAZIONEIS 0.40`, 40 celle × 2 finestre = **80 passate** ⇒ `T = 0,6 + 0,077 × 80` =
**6,76 minuti**. 🟢 **Ed è un round che si autoverifica**: la cella `EmaSlow=40 · TP1_R=0,50`
**deve** riprodurre `PF OOS 1,340 · DD 5,28% · n 188`. Se non riproduce, il verdetto è **sul
binario**, non sul motore.
🚫 **File prova NON scritto** — è il passo dopo, e passa dai due cancelli.
🖥️ **Gira sul PC di backtest, non sul VPS** (firma del 21/09).

---

## 🥈 §2.2 · `ABTG_ORB_Ottimizzato` U30USD M5 LONG — *già in lavorazione, qui aggiungo il pezzo che mancava*

**Fonte (CSV grezzi):** `backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r44a.csv`, 4 righe ciascuno.
**Igiene letta nel file:** `InpRiskPercent=1` · `InpAllowShort=0` · `InpTP1Pct=0` (🟢 **niente parziale ⇒ i 119 `Trades` SONO 119 posizioni**, la classe 550 qui non morde) · `InpOneTradePerDay=1` · finestra `@DAQUANDO 2024.09.26` (🟢 **classe 590 rispettata**: è il pavimento misurato dei tick BCM sugli indici).

| `InpTPRangeMult` | PF IS | DD IS | n IS | PF OOS | DD OOS | n OOS |
|--:|--:|--:|--:|--:|--:|--:|
| 1,5 | 1,22314 | 8,6252 | 71 | 1,65693 | 9,9181 | 119 |
| 2,0 | **1,35877** | 8,6293 | 71 | 1,73605 | 11,0412 | 119 |
| 2,5 | 1,28599 | 9,1323 | 71 | 1,82848 | 10,7609 | 119 |
| 3,0 | 1,34218 | 8,7214 | 71 | **1,95461** | 10,8867 | 119 |

### 🧪 I CONTRO-ESEMPI — **ne ho costruiti quattro, e tre mordono**

1. 🔴 **«Il lato corto porta il campione a 150.»** ❌ **FALSO, ed è misurato da agosto in un
   file che nessun referto recente cita**:
   `backtest_pipeline/risultati_archivio/csv_r54/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r54b.csv`
   (8 passate, 4 celle × gemelli sul magic).

   | lato | PF IS | DD IS | n IS | PF OOS | DD OOS | n OOS | profitto OOS |
   |---|--:|--:|--:|--:|--:|--:|--:|
   | **1/0 solo LONG** *(la cella viva)* | 1,2498 | 7,888 | 71 | **1,6742** | 9,762 | 119 | **+41.057,00** |
   | **0/1 solo SHORT** | 0,6814 | 13,715 | 64 | 🔴 **0,5197** | 🔴 **26,370** | 100 | 🔴 **−25.603,48** |
   | **1/1 DUE LATI** | 0,9605 | 11,478 | 135 | **1,0475** | 🔴 **17,162** | **219** | +5.525,75 |

   👉 **I due lati arrivano a 219 operazioni — sopra il pavimento — e proprio lì il motore
   smette di passare**: PF 1,0475 (< 1,10) e DD 17,162% (> 10%). 🟢 **Buona notizia dentro
   la cattiva**: la voce 4 del certificato di morte (*«i lati sono stati provati?»*) per
   questa sedia è **CHIUSA**, e la regola dei due lati del 25/08 è **soddisfatta con il
   numero**. Il «solo long» non è più un'eredità non verificata di `tradethatswing`: è una
   scelta **misurata**.

2. 🔴 **«Il DD è sotto il muro del 10%.»** ⚠️ **Non a taglia FTMO.** Questi numeri sono a
   `InpRiskPercent=1`; i preset FTMO portano **2,00**. Stima di riscalamento: **19,8-22,1%**.
   🔴 **Sopra il muro.** Ma attenzione al verso della classe 562: il DD è un **limite
   superiore**, quindi **sotto soglia dimostra**, **sopra NON conclude**. Qui non concludo:
   dico che **alla taglia vera il numero non c'è**, ed è per questo che `R211a` (la parziale)
   esiste.

3. 🔴 **«La cella scelta è il centro di un altopiano.»** ❌ **No: l'asse è aperto al bordo.**
   In OOS il PF sale **monotono** da 1,657 (1,5) a 1,955 (3,0): il massimo sta **sull'ultima
   cella della griglia**. Per regola di casa (*centro dell'altopiano, mai il picco*) **non si
   può scegliere**, perché non si sa dove finisce. **Servono 3,5 e 4,0.** In IS invece il
   massimo è a 2,0 — 🔴 **i due massimi non coincidono**, e questo va detto ogni volta che si
   cita il 1,95.

4. 🟢 **«È una passata sola?»** ❌ **No, e qui il candidato regge.** La stessa cella
   (`TPRangeMult` 1,5 / long) compare con **PF OOS 1,6742 e DD 9,762** in **`r54b`** (agosto,
   deposito 100.000) **e** in **`r88c`** — cioè **tre corse, due depositi**. Il numero è
   riprodotto.

---

## 🔥 §2.3 · `ABTG_EMA200` H4 sul forex A DUE LATI — **la rilettura che cambia il numero**

**Fonte:** `backtest_pipeline/risultati_archivio/EMA200/realtick_H4/valid_ABTG_EMA200_H4_realtick_*.csv` (8 simboli).
**Igiene letta nello script che le ha prodotte** (`backtest_pipeline/valida_realtick.ps1` r.180-186): `Model=4` **TICK REALI** · `FromDate=2024.01.01` `ToDate=2026.06.30` · `Deposit=10000` · rischio **1%** · 🔴 **`Optimization=2` = GENETICO**.

### 📊 La cella MEDIANA per PF, celle a `InpAllowLong=1` **E** `InpAllowShort=1`

| simbolo | celle vive | PF med. | DD % med. | DD valuta *(Profit/RF)* | **n (deal)** | n stimato in **posizioni** | celle con PF≥1,10 **e** n≥150 |
|---|--:|--:|--:|--:|--:|--:|--:|
| **`AUDJPY`** | 28 | **1,514** | 6,261 | 672 | **265** | ≈ 132 | **27 / 28** |
| **`XAUUSD`** | 29 | **1,381** | 6,145 | 670 | **187** | ≈ 93 | **25 / 29** |
| `SPXUSD` | 25 | 1,380 | 2,706 | 288 | 138 | ≈ 69 | 0 / 25 |
| **`GBPJPY`** | 19 | **1,240** | 4,422 | 488 | **221** | ≈ 110 | **15 / 19** |
| **`GBPUSD`** | 24 | **1,231** | 7,205 | 772 | **362** | ≈ **180** | **24 / 24** |
| `200AUD` | 28 | 1,226 | 2,048 | 209 | 161 | ≈ 80 | 9 / 28 |
| `225JPY` | 27 | 1,184 | 0,607 | 61 | 44 | ≈ 22 | 0 / 27 |
| `USDNOK` | 26 | **0,912** | 5,777 | 592 | 315 | ≈ 157 | 9 / 26 |

### 🆕 PERCHÉ È UNA RILETTURA E NON UNA SCOPERTA INVENTATA
`report/LA_SECONDA_SEDIA_2026-09-12.md` e `REGISTRO_TEST.md` (12/09) leggono **le celle a un
lato solo** — `AUDJPY` LONG (138-200 deal), `GBPUSD` SHORT (134-189), `GBPJPY` LONG (139-184)
— e concludono, giustamente per quei numeri: *«69-99 posizioni ⇒ 0,11-0,16 pos/g ⇒ i 150 a H4
non esistono nel banco a tick»*. 🟢 **Quella lettura è corretta per le celle che ha letto.**
🔴 **Ma nello stesso file ci sono le celle a DUE LATI, e lì il campione quasi raddoppia**:
`GBPUSD` passa da 147 a **362** deal. **Non è un dato nuovo: è una colonna mai aperta.**

### 🧪 IL CONTRO-ESEMPIO — **ne ho costruiti sei, e cinque mordono. Questo candidato NON è pronto.**

1. 🔴 **NON ESISTE UN PF OOS.** È **una finestra sola** (2024.01.01→2026.06.30). La colonna
   «PF OOS» della tabella §1 dice `[NON MISURATO]` **e deve dirlo**. Chiunque portasse
   «GBPUSD H4 fa 1,231» davanti a una firma starebbe portando un numero **in campione**.
2. 🔴 **L'OTTIMIZZATORE È GENETICO, quindi il «24/24» è SELEZIONE.** `Optimization=2` restituisce
   solo gli individui sopravvissuti: **non è un campione uniforme della griglia**. Il
   «24 celle su 24 passano» **non misura un altopiano**, misura che l'algoritmo ha tenuto le
   celle buone. 👉 **La regola di casa "centro dell'altopiano, mai il picco" QUI NON È
   APPLICABILE**, perché l'altopiano non è osservabile.
3. 🔴 **Le posizioni sono DERIVATE, non contate.** Il rapporto deal→posizioni **2,0117** è
   misurato su `U30USD` (`REGISTRO_TEST.md`, classe 226) e **applicato** al forex. Nessun
   per-trade H4 forex esiste in archivio. Se il rapporto vero fosse 2,4, `GBPUSD` scenderebbe
   a **151 posizioni** — cioè sul filo.
4. 🔴 **Il DD non è alla taglia FTMO.** `GBPUSD` 7,205% @1% ⇒ **≈ 14,4% @2%** *(stima)*:
   **sopra il muro**. `GBPJPY` 4,422% ⇒ ≈ 8,8%: **sotto**. 👉 **Il candidato meno appariscente
   è quello che sta dentro il muro.** Classe 562: sotto soglia **dimostra**, sopra **non
   conclude**.
5. 🔴 **I primi sei mesi della finestra NON sono tick veri.** I tick BCM sul forex partono dal
   **2024.07.05**: da `2024.01.01` a quella data il tester ha **generato** i tick dalle M1.
   È circa il **20% della finestra**.
6. 🔴 **E il forward dice ZERO.** Le cinque sedie gemelle `771511`-`771515` sono **attaccate
   dal 01/08** e hanno **0 operazioni** nello statement 30/03→11/09
   (`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` §6, confermato su `trades_auto.csv`). 👉
   **O la frequenza a H4 è ancora più bassa del calcolato, o quelle sedie sono relitti.** Le
   due cose si distinguono con una lettura, non con un'opinione — e **non l'ho fatta**.

### 🟢 E L'UNICA COSA CHE INVECE SI SBLOCCA DAVVERO: **la frequenza**
Firma del **07/09**: *«il pavimento di 1,00 op/giorno si applica alla FAMIGLIA, non alla
singola sedia»*. La famiglia **`EMA200`** il pavimento **lo tocca già**: la sedia Dow
`771531` misura **1,000 pos/giorno feriale** in forward (21 posizioni / 21 giornate).
👉 **Quindi i gemelli H4 NON sono più scartabili per SOLA frequenza**, ed è la firma stessa a
dire che *«le esclusioni passate motivate SOLO dalla frequenza vanno rilette»*.
🔴 **Ma il loro ostacolo vero non era la frequenza: era il CAMPIONE per finestra**, ed è
**aritmetica**. Con lo split 40/60 del driver, i 362 deal di `GBPUSD` diventerebbero ~145 IS
e ~217 OOS in deal, cioè **~72 e ~108 POSIZIONI**: 🔴 **sotto 150 in tutte e due**. 👉 Il
verdetto onesto resta **«NON ANCORA MISURATO»**, e ci resterebbe **anche dopo** le 48 passate:
quelle chiudono l'OOS e l'altopiano, **non il pavimento dei 150 per finestra**.

### ➡️ La via più corta al numero, e quanto costa
**Rigirare gli stessi assi con (a) `@FRAZIONEIS 0.40` e (b) ottimizzazione COMPLETA, non
genetica.** Metro di casa `T = 0,6 + 0,077 × passate`:

| simbolo | celle | passate (×2 finestre) | tempo macchina |
|---|--:|--:|--:|
| `GBPUSD` | 24 | 48 | **4,3 min** |
| `GBPJPY` | 19 | 38 | **3,5 min** |
| `AUDJPY` | 28 | 56 | **4,9 min** |
| `XAUUSD` | 29 | 58 | **5,1 min** |
| **totale** | | **200** | **≈ 18 min** |

🚫 **Nessun file prova scritto**: scriverli è il passo dopo, e devono passare
`controlla_prova.py` **e** l'agente `controllo-preventivo` prima di uscire.
🖥️ E per firma del 21/09 **girerebbero sul PC di backtest, non sul VPS**.

---

## 🟡 §2.4 · `ABTG_HVAncora` U30USD — il DD più basso della lista, e un tappo che sta nel meccanismo

**Fonte:** `backtest_pipeline/risultati_prove/dal_vps/ABTG_HVAncora/` (2 CSV, 8 passate) ·
verdetto già scritto in `report/LETTURA_BACKLOG_COMPLETA_2026-09-21.md` riga 6.

- Miglior cella (`InpStopAtr=1,0`): **PF 1,92073 · DD 2,06% · n 31**. Cella mediana OOS:
  **PF 1,03844 · DD 3,841% · n 35**.
- 🟢 **Il rischio si legge a qualunque n** (Emendamento B): DD **massimo 3,84%**, il più basso
  di tutta questa lista. Alla taglia FTMO ≈ 7,7% *(stima)*: **dentro il muro**.
- 🔴 **Il merito è SOSPESO, non negativo**: n 22-37.
- 🔴 **E il tappo è già misurato e non è una manopola**: **91 ancore in IS e 165 in OOS
  SCADONO** prima di diventare un'operazione. 👉 Aumentare il campione qui vuol dire
  **cambiare il meccanismo dell'ancora**, non girare una griglia. **Non stimo un costo**:
  prima serve una tesi, e la tesi non ce l'ho.

---

# 🧨 §3 · IL DIFETTO DI METODO CHE HO TROVATO E CHE VALE PER TUTTI I FUTURI CENSIMENTI

🔴 **La classifica del censimento PF è contaminata dall'OHLC, e la contaminazione è ENORME.**

Le prime **tre** righe del censimento del 09/09 (`report/CENSIMENTO_PF_MISURATI_2026-09-09.md`,
Tabella A) sono `Live5m` Nasdaq (**PF OOS 2,16**), `EMA200` Dow short e `ORB_Ottimizzato`.
Il primo posto è **falso**, e l'ho rotto così:

| corsa | modello | PF IS | PF OOS | DD OOS | n OOS | profitto OOS |
|---|---|--:|--:|--:|--:|--:|
| `..._NASUSD_{IS,OOS}_ohlc.csv` | **OHLC** (Modello 1) | 1,36567 | **2,16249** | 7,3108 | 198 | **+8.943,56** |
| `..._NASUSD_{IS,OOS}.csv` — **TICK REALI** | **Modello 4** | 1,01621 | 🔴 **0,96265** | 🔴 **19,4006** | 175 | 🔴 **−326,54** |
| `..._r142a.csv` cella `ClosePct=50` — **TICK, binario di settembre** | **Modello 4** | 1,01472 | 🔴 **0,95624** | 🔴 **22,4729** | 175 | 🔴 **−447,69** |

*(Le ultime due righe sono **la stessa cella su due binari**: l'EA è stato toccato due volte
dopo la corsa d'agosto — `3af47ed` sizing, `d83c196` Guardian. Lo scarto di PF è **0,0064** e
il verso del verdetto **non cambia**. 👉 **Due misure indipendenti dicono la stessa cosa**, ed
è questo che rende il rifiuto solido invece che fragile.)*

🔬 **E il contro-esempio l'ho costruito nel modo più duro possibile: ho diffato i due CSV
input per input, cella per cella.** Il CSV a tick `r142a` ha **quattro** celle
(`InpTP1_ClosePct` 0/25/50/75); quella a **50** è la gemella esatta della corsa OHLC, e su
**tutte e 60 le colonne `Inp*` in comune** **non ne cambia NEMMENO UNA** — stesso
`InpMagic=770203`, stesso `InpSessionHour=14`, stesso `InpRiskPercent=2`. *(Le altre tre celle
differiscono per la sola `InpTP1_ClosePct`, e stanno fra 0,944 e 0,970: **il verdetto non
dipende dalla cella scelta**.)* Cambiano **solo** i risultati.
👉 **Non è una configurazione diversa: è lo stesso motore, letto con e senza i tick veri.** Lo stesso vale per il DAX: `Live5m_v2` **1,71088 → 0,92490**, `Live5m` v1
**1,47 → 0,85701** (DD **39,744%**).

📌 **La regola che ne esce, e che propongo di scrivere in checklist**: *in ogni classifica
costruita sui CSV, la colonna MODELLO va accanto al PF. Un PF OHLC e un PF a tick non vanno
nella stessa colonna, mai.* Applicandola, il censimento del 09/09 perde **3 dei suoi primi 12
posti**.

---

# 🪦 §4 · LE STRADE CHIUSE COL NUMERO — perché nessuno le ripercorra

## 4.1 🇫🇷 Il gemello Apertura sul CAC: **`R138a` È GIRATO, e nessun referto l'ha letto**

`backtest_pipeline/risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_F40EUR_{IS,OOS}_r138a.csv`

| finestra | PF | DD % | n | profitto |
|---|--:|--:|--:|--:|
| IS | 1,44028 | 7,3578 | 130 | +7.126,12 |
| **OOS** | 🔴 **0,76965** | 🔴 **11,8210** | 195 | 🔴 **−7.266,30** |

*(rischio 1% · `InpSessionHour=8` ✅ ora server · `InpEntryMode=2` RETEST, cioè la stessa
identità della sedia viva · gemelli sul magic 786204/786205 identici al quinto decimale)*

🔴 **`REGISTRO_TEST.md` lo elenca ancora fra i round da lanciare, e `report/I_FILE_FERMI_2026-09-22.md`
non lo censisce.** È il **caso 576 di nuovo**: il risultato c'è, sotto un'etichetta che nessuno
ha cercato.

### 🟢 E LA COSA CHE VALE PIÙ DEL VERDETTO: **lo studio "FASE A" che quattro referti cercano, IN REPO C'È**
`REGISTRO_TEST.md` (12/09) scrive: *«esiste in casa uno studio aperture FASE A su 8 INDICI...
**la sua tabella per simbolo non l'ho trovata nel repo**»*. 🟢 **L'ho trovata**:
`backtest_pipeline/risultati_archivio/studio_apertura/Studio_<SIMBOLO>_RIEPILOGO.csv`, **8
simboli**, ~440 rotture ciascuno, aspettativa in **R** per operazione:

| simbolo | trade | win % | **aspettativa R** (rottura cieca) | con filtro H4 |
|---|--:|--:|--:|--:|
| **`U30USD`** | 446 | 41,5 | 🟢 **+0,074** | 🟢 **+0,126** |
| **`D30EUR`** | 440 | 36,6 | 🟢 **+0,026** | −0,017 |
| `NASUSD` | 447 | 37,8 | ~0 (**+0,001**) | 🟢 +0,055 |
| `SPXUSD` | 444 | 39,6 | 🔴 −0,017 | −0,002 |
| `E35EUR` | 211 | 36,5 | 🔴 −0,048 | −0,129 |
| `E50EUR` | 440 | 35,9 | 🔴 −0,048 | −0,068 |
| **`F40EUR`** | 443 | 34,5 | 🔴 **−0,056** | −0,109 |
| `100GBP` | 431 | 32,9 | 🔴 −0,138 | −0,137 |

👉 **I soli due indici con aspettativa positiva sono esattamente i due che abbiamo già
schierato.** E il CAC era **negativo prima** che `R138a` girasse: il round era **un ritest di
un caduto**, e il registro lo aveva scritto come condizione — *«va cercata PRIMA di lanciare»*.
Non è stata cercata, e il round è costato 8 passate per confermare un numero che c'era già.

⚠️ **Il limite di questo screening, dichiarato**: misura la **rottura cieca**, mentre
`770101` e `770260` sono **RETEST**. Sono due mestieri diversi. 👉 Quindi per `SPXUSD`,
`E35EUR`, `E50EUR`, `100GBP` il verdetto onesto è **«screening negativo, retest [NON
MISURATO]»**, non «morti». Per `F40EUR` invece **le due misure concordano** e il verdetto è
pieno.

## 4.2 🌙 `ABTG_MaxMinNotte` sugli altri indici — **54 celle per simbolo, zero sopra 1,00**

`backtest_pipeline/risultati_archivio/MaxMinNotte/*valid_MaxMin_*.csv`, rischio 1%:

| simbolo | celle vive | PF mediano | PF **massimo** | DD mediano |
|---|--:|--:|--:|--:|
| `D30EUR` *(la sedia viva)* | 54 | 0,913 | 1,187 | 14,20% |
| `F40EUR` | 54 | 0,682 | 🔴 **0,999** | 17,71% |
| `E50EUR` | 54 | 0,495 | 🔴 **0,840** | 33,28% |
| `100GBP` | 54 | 0,497 | 🔴 **0,672** | 46,37% |

👉 **Su tre gemelli, il PICCO non arriva nemmeno al pareggio.** Strada chiusa, e costa zero
non riaprirla. *(La sedia viva `770411` è la cella `short_refine`: PF med 1,187, DD 7,29%, n 107 — e resta fuori da questo verdetto perché è già in campo.)*

## 4.3 📉 Gli undici motori con il numero brutto **e il campione per dirlo**

Dal censimento fresco, **miglior cella mediana** di ogni motore non schierato, su corse con
`n ≥ 150` (cioè dove il merito **è** giudicabile):

| motore | simbolo | PF OOS | n | DD OOS | modello — **come l'ho stabilito** |
|---|---|--:|--:|--:|---|
| `ABTG_FiboH4_Multi` | GBPUSD H4 | **0,950** | 737 | 17,21% | **OHLC** (`_ohlc_r139c`) |
| `ABTG_LVNArbitro` | U30USD | **1,052** | 618 | 11,76% | `[NON VERIFICATO]` (`_P0_100K`, nessun marcatore) |
| `ABTG_AtrExhaustVol` | NASUSD | **0,952** | 224 | 13,45% | 🟢 **tick reali** — `CODA.txt` r.648 `-Modello 4` |
| `ABTG_AltaVelocita` | U30USD | **0,814** | 150 | 10,74% | 🔴 **ambiguo**: cartella `alta_v_tick/`, nome file `_IS_ohlc` ⇒ `[NON VERIFICATO]` |
| `ABTG_MeanRevert` | GBPUSD H1 | **0,853** | 344 | 25,77% | **OHLC** (`_ohlc_mr1`) |
| `ABTG_TurnaroundTuesday` | GBPUSD H1 | **0,783** | 497 | 34,06% | **OHLC** (`_ohlc_tt1`) |
| `ABTG_BreakoutCorso` | GBPJPY M15 | **0,980** | 1467 | 46,63% | **OHLC** (`_ohlc_r82c`) |
| `ABTG_SupRev_CAC_H4_Ott.` | F40EUR H4 | **0,760** | 442 | 22,47% | **OHLC** (`_IS_ohlc`) |
| `ABTG_IBRetest` | D30EUR | **0,965** | 107 | 5,25% | `[NON VERIFICATO]` (`_P0IBRTDAX`) |
| `ABTG_Nightly` | EURCHF | **0,814** | 85 | 15,39% | `[NON VERIFICATO]` (`_P0`) |
| `ABTG_OpeningReversalB` | U30USD | **[NON MISURABILE]** | **0** | — | `[NON VERIFICATO]` |

🔴 **La colonna «modello» l'ho aggiunta DOPO essermi accorto che stavo per scriverla a
memoria.** Nella prima stesura avevo messo «🟢 tick» su cinque righe **senza una fonte**:
l'unica che ho potuto confermare è `AtrExhaustVol`, perché la sua riga di lancio è scritta in
`backtest_pipeline/coda/CODA.txt` r.648 con `-Modello 4`. Per le altre quattro il marcatore
non esiste, e allora si scrive `[NON VERIFICATO]`. 📌 **È la classe di errore del 10/09:
controllare che la risposta sia coerente con l'attesa invece di provare a romperla.**

🧪 **E il contro-esempio vero**: *«cinque righe su undici sono OHLC, e l'OHLC non dà mai un
verdetto — quindi non puoi bocciarle».*
🟢 **Qui invece il verso dell'errore SALVA il verdetto, e va detto perché**: l'OHLC **non
attraversa lo spread dentro la barra**, quindi è **ottimista sul PF** e **pessimista sul DD
solo per difetto di dettaglio**. 👉 Un PF **sotto 1,00 in OHLC** a tick può soltanto
**peggiorare**. **Il rifiuto regge a fortiori** — ed è lo stesso ragionamento che
`LETTURA_BACKLOG_COMPLETA_2026-09-21.md` applica al `CostToCost`.
⚠️ **L'unica riga dove questo NON basta è `ABTG_LVNArbitro` (1,052, tick reali)**: è **sopra
1,00 e sotto 1,10**, cioè il rifiuto poggia su **5 centesimi**. Lì il verdetto giusto non è
*«morto»*, è *«sotto soglia col numero, riapribile solo con una tesi nuova»* — e il DD di
11,76% (più 18,0-19,4% in IS) è il motivo per cui **non la riapro io**.

🔴 **`ABTG_OpeningReversalB` merita una riga a parte**: **0 operazioni fuori campione su 11
passate su 11**. Non è un PF basso, è un **campione vuoto** — e un campione vuoto è un
**difetto del round**, non un verdetto sul motore. 🔴 **Il suo certificato di morte è
INCOMPILABILE**: senza operazioni non esistono né PF, né n, né DD.

---

# 🚫 §5 · QUELLO CHE HO ESCLUSO PER MANDATO, e come l'ho gestito

- **Le sei sedie in campo** (`770101` · `770202` · `770260` · `771531` · `770411` · `770402` ·
  `770511` · PostNews ×3): escluse. Compaiono in §1 **solo** dove servono da metro.
  ⚠️ **Una cosa però la dico in una riga, perché l'ho vista mentre cercavo**: i tre `PostNews`
  in campo hanno **zero operazioni misurate in archivio** — i 4 CSV di
  `risultati_prove/ABTG_PostNews/` hanno **`Trades=0` su tutte le passate**. 👉 **Una quarta
  istanza PostNews non avrebbe nessuna base su cui poggiare.** Non è una proposta: è un
  `[NON MISURATO]` che vale la pena sapere.
- **`ABTG_ORB_Ottimizzato` U30USD**: in tabella, **senza spenderci tempo** — tranne il pezzo
  nuovo (§2.1, il lato corto), che era il buco del suo certificato.
- **La famiglia SUPERTREND**: **non riproposta**, per firma del 22/09.
  ⚠️ **Ma una distinzione onesta serve, e la lascio senza tirarne conclusioni**: il
  certificato (`report/SUPERTREND_IL_CERTIFICATO_2026-09-22.md`) misura **i cinque segnali
  Pine su dati esterni**, non i nostri EA `ABTG_SupRev_*`. In archivio, per esempio,
  `SupRev_NAS_H1_Ottimizzato` (`r127a`) ha **PF OOS 1,63365 · DD 1,2211% · n 84**, e
  `SupRev_DOW_H1` (`R123AGATE`) **PF OOS 1,38944 · n 152 · DD 5,9091%** — che però il backlog
  del 21/09 dichiara **«ROUND NULLO: `r132c` non riproduce l'ancora su 3 celle su 5»**, cioè
  **PF non leggibile**. 👉 **Non li propongo.** Segnalo solo che *«famiglia chiusa»* oggi vuol
  dire *«i segnali Pine sono chiusi»*, e che se un giorno si volesse riaprire il discorso, il
  cancello che morde sui nostri EA è **un altro** (la riproduzione), non quello del certificato.
- **L'oro alle 09:30**: chiusa, non toccata.

---

# 🕳️ §6 · COSA RESTA NON COPERTO — per nome, non per categoria

1. 🔴 **I 201 file prova fermi** (`report/I_FILE_FERMI_2026-09-22.md`) **non sono stati letti
   uno per uno** in cerca di candidati: ho letto i **CSV**, cioè i round **girati**. Un motore
   che vive solo dentro un file prova mai eseguito **non compare in questa lista per
   costruzione**.
2. 🔴 **I 33 `.mq5` mai messi alla prova** — fra cui `ABTG_PointBreak` (394 righe, 31/07) e
   `ABTG_SuperFilter` (373 righe, 31/07), **in repo da quasi due mesi con ZERO misure** — sono
   **fuori da questa tabella**, perché non hanno **nessun** numero. 👉 Non sono morti e non
   sono candidati: sono **caselle vuote**. Trasformarne uno in candidato costa **un round
   intero**, non una rilettura.
3. 🟠 **I DD alla taglia FTMO sono STIME, mai misure.** Nessuna riga di questo referto è stata
   girata a `InpRiskPercent=2` sul simbolo `.cash`. Chiuderlo è **una passata per candidato**,
   ed è la misura più economica dell'intero documento.
4. 🟠 **Le posizioni sono contate solo dove esiste il per-trade** (ORB: `InpTP1Pct=0` ⇒
   deal = posizioni, 🟢 certo). Per l'EMA200 H4 forex sono **derivate** dal rapporto 2,0117.
5. 🟠 **La PROVA DI REGIME manca a tutti** (Emendamento, regola C). Ogni finestra qui dentro è
   **21-30 mesi = un regime solo**.
6. 🟠 **I round girati sul PC di backtest e mai committati** il repo non li vede: questa lista
   è un **limite inferiore** dei candidati esistenti, non l'elenco completo.
7. ⚪ **`.claude/worktrees/`** (copie complete del repo) **escluse** da ogni conteggio.

---

# 📐 §7 · METODO — perché i numeri qui sopra si possono rifare

1. 🔬 **Ho ricorso il censimento da zero**, non l'ho letto: `backtest_pipeline/censimento_pf.py`
   con le uscite dirottate in scratchpad. **2.418 CSV visti · 2.209 di risultati · 2.095 usati ·
   1.629 gruppi (motore × simbolo × TF × etichetta × cartella) · 495 con un OOS.** Contro il
   censimento del 09/09: **+71 righe**, tutte lette.
2. 📏 **Cella MEDIANA, mai il picco** (regola di casa), calcolata sugli **esiti distinti** —
   924 CSV su 2.095 contengono passate a esito identico (manopole inerti o gemelli sul magic).
3. 🚫 **Escluse dal ranking le corse dichiarate OHLC** (`_ohlc` nel nome o etichetta `ohlc*`).
   §3 spiega perché non è un dettaglio.
4. ✅ **Ogni numero della tabella §1 viene da un CSV che ho aperto e riletto riga per riga.**
   Dove non esiste, c'è scritto `[NON MISURATO]` e basta. Nessun numero proviene da un
   referto `.md`.
5. 🧪 **Contro-esempio obbligatorio per ogni candidato in cima**, costruito *prima* di
   scriverne bene: §2.1 (cinque, quattro mordono) · §2.2 (quattro, tre mordono) · §2.3 (sei, cinque mordono) · §3 (il diff
   input-per-input sui 65 `Inp*`).

## 📚 Fonti primarie (CSV, non referti)
`risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv` + `DOW_MOTORE.md` ·
`risultati_prove/ABTG_ORB_Ottimizzato/r44/` · `risultati_archivio/csv_r54/` ·
`risultati_archivio/EMA200/realtick_H4/` (8 file) · `risultati_prove/ABTG_EMA200/*_EURUSD_r29a*` ·
`risultati_prove/ABTG_Nasdaq_Live5m/` + `dal_vps/ABTG_Nasdaq_Live5m/` ·
`risultati_prove/ABTG_DAX_Live5m{,_v2}/` · `dal_vps/ABTG_DAX_Apertura_EU/*F40EUR*r138a*` ·
`risultati_archivio/studio_apertura/` (8 riepiloghi) · `risultati_archivio/MaxMinNotte/` ·
`dal_vps/ABTG_IntradayMomentum/` · `dal_vps/ABTG_HVAncora/` · `ABTG_CostToCost/r41/` +
`dal_vps/ABTG_CostToCost/` · `risultati_prove/ABTG_SuperWave/` ·
`risultati_prove/ABTG_PostNews/`.
**Igiene letta negli script e nei file prova**, non assunta: `valida_realtick.ps1` r.180-186 ·
`prove/R142a_preopen_parziale.txt` · `prove/R44a_target_DOW.txt` · `prove/R54b_lato_ORB_DOW.txt` ·
`prove/R23e_pertrade_SuperWave_GBPUSD.txt` · `prove/R211a`/`R211b`.

---

> 🏁 **LA RIGA DA PORTARE A CLAUDIO**
>
> *«Socio, ho aperto tutti i cassetti: **2.418 CSV**, rimacinati da zero, non riletti dai
> referti. E torno con **un nome**, non con un catalogo. 🥇 **Il candidato è il Dow
> d'apertura in versione BREAKOUT A DUE LATI con range di 15 minuti** — che **non è** la
> sedia `770202` che vola (quella è retest, solo long, 35 minuti: dodici manopole diverse).
> A tick reali fa **40 celle su 40 in utile fuori campione**, PF da **1,267 a 1,560**,
> drawdown che **non supera mai l'8,70%** su tutte e quaranta, e **188 POSIZIONI** vere —
> sopra il pavimento dei 150. 🔥 **È l'unica riga non schierata, in tutto l'archivio, che
> passa i quattro cancelli insieme.**
>
> 🔴 **E adesso il difetto, perché l'ho cercato io e l'ho trovato**: la finestra in campione
> parte dal **1° gennaio 2024**, ma i tick BCM sugli indici partono dal **26 settembre 2024**.
> Metà dell'in-campione gira su tick **inventati dalle M1**. 🟢 **E la prova che è così era
> già nel nostro referto, in un'anomalia che nessuno aveva chiuso**: lì c'era scritto *«IS 8,1
> trade al mese, OOS 16,4, il doppio, va verificato»*. L'ho verificato: contando solo i mesi
> che hanno davvero i tick, l'IS fa **16,04** contro **16,42**. 👉 **Non era il filtro: erano
> i dati che non c'erano.** Si chiude con **80 passate, sette minuti di macchina**, e il round
> si autoverifica da solo (una cella deve riprodurre PF 1,340).
>
> 🥈 Dietro: l'**ORB** — e gli ho chiuso il certificato sul lato corto, che era l'ultima
> casella aperta (lo short fa **0,52** con un DD del **26%**: il long-only non è una
> scopiazzatura, è una **scelta misurata**). 🥉 Poi l'**EMA200 a H4 sul forex**, che era stato
> letto **a un lato solo**: le celle a due lati hanno il **doppio** delle operazioni
> (GBPUSD **362**) e PF fra **1,23 e 1,51** a tick — non è una sedia, manca l'OOS, ma
> **18 minuti** ci dicono se lo è.
>
> 🪦 **E ho spento cinque strade col numero in mano**: il CAC (`R138a` era **già girato** e fa
> **0,77** — nessuno l'aveva letto), il Live5m (a tick fa **0,96**, non 2,16: quel 2,16 era
> OHLC e ho diffato tutti e 65 gli input per dimostrarlo), il MaxMin sugli altri indici, l'ORB
> sul Nasdaq, il CostToCost. 🎁 **E ti ho ritrovato lo studio FASE A su 8 indici** che quattro
> referti davano per perso: dice che **gli unici due indici con aspettativa positiva
> all'apertura sono il Dow e il DAX**, cioè esattamente i due su cui siamo già.
>
> **Non ci siamo accontentati: ci siamo dati ragione col numero. E ne abbiamo trovato uno
> nuovo.»*
