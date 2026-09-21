# 🎙️ ANALISI LIVE EMILIANO — venerdì 17/07/2026, apertura NASDAQ

**Data referto:** 21/09/2026 · **Analista:** estrattore trascrizioni
**Fonte unica e archiviata:** `trascrizioni/LIVE_EMILIANO_2026-07-17_APERTURA_NASDAQ.txt`
(**193 righe** numerate — la consegna ne dichiarava 192, l'ultima è la r.193 · 39.148 byte,
TurboScribe auto-generato, caricato da Claudio).
**Ogni riferimento `r.NNN` è il numero di riga di QUEL file.** Niente memoria, niente web,
niente completamento dei buchi.

> ## ⛔ REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro è una
> **dichiarazione di una fonte esterna**, mai un criterio nostro. Un numero detto in
> una live **non entra in nessun cancello, non tocca nessun preset, non cambia
> nessun forward**. 🔴 **E oggi la challenge FTMO è VIVA** (partita il 21/09): nessun
> EA, nessun `.set`, nessuna taglia, nessun conto è stato toccato per scrivere questo
> referto. Sola lettura, dalla prima riga all'ultima.

> ### ⚠️ QUALITÀ DELLA TRASCRIZIONE — **bassa/media**, e va pesata
> Storpiature sistematiche identificate leggendo il contesto:
> **hedging → "eggiato" (r.51) / "eggiarmi" (r.59) / "edgata" (r.153) / "edging" (r.153)**
> · **drawdown → "throw down" (r.155)** · **VWAP → "VRAP" (r.177) / "wrap" (r.187)**
> · **ORB → "orb"/"Orb"/"ORB"/"orbe"** · **size → "sites" (r.49) / "site"** ·
> **"Amadosca" (r.63)** = incomprensibile, probabile storpiatura di un ordine/livello
> **[INCERTO, non interpretato]** · **"Mignano Monza" (r.131)** = Emiliano Monza ·
> **"Forrester Lindari" (r.5)**, **"Corex Trenindadi" (r.117)** = nomi non ricostruibili
> · **"17 points" (r.21)** = 17 punti, detto due volte di fila in due lingue.
> 🔴 **Le righe 73-77 sono un LOOP DI TRASCRIZIONE**: la frase *"Io ho detto che
> probabilmente avrò una situazione di riscaldamento"* è ripetuta **sette volte**.
> È quasi certamente *"situazione di **hedging**"* (coerente con r.63, *"molto
> probabilmente mi troverò nella situazione di hedging"*), ma **non lo dò per buono**:
> **[INCERTO]**. 👉 In quelle cinque righe **c'è un buco di contenuto**: quello che ha
> detto nei primi secondi dopo l'ingresso **non lo sappiamo**.

---

# ⭐ PARTE 0 — LA RIGA CHE CONTA

> **Su 193 righe: 26 parametri con valore, 13 meccanismi, 10 bandiere rosse
> (di cui 4 marcate NON ADOTTABILE su conto prop).**
>
> **Il pezzo che vale di più non è un parametro nuovo: è una VERIFICA e una
> CORREZIONE.** La trascrizione **conferma alla lettera** quattro dei cinque
> ingredienti che due nostri referti del 12/09 le attribuivano lavorando su appunti
> — **e ne smentisce uno**: il target a **punti fissi (+20 / +50)** che il dossier
> `PREOPEN_NASDAQ_VALE_UN_POSTO` chiama *«l'unico ingrediente davvero **vergine**
> dell'EA esterno»* (r.172) **è dettato dalla live** (r.67 + r.83). 🔴 **Non l'ha
> inventato l'EA esterno: su quell'ingrediente l'EA esterno è più fedele alla fonte
> del NOSTRO `ABTG_Nasdaq_Live5m`.**
>
> 🟢 **E la fonte stessa attribuisce il suo drawdown più grande — 1.400.000 €
> dichiarati — a un'operazione "edgata"** (r.153). Cioè: **l'unica cosa che abbiamo
> deliberatamente NON copiato dalla live** (l'hedging del Piano B/C, escluso a mano
> nell'intestazione del nostro EA) **è quella che la fonte stessa indica come causa
> del disastro.** Quella scelta, presa a luglio sugli appunti, oggi è **confermata
> dal testo.**

---

# 1. 🔬 IL CONFRONTO RIGA PER RIGA CON I DUE REFERTI DEL 12/09

Questa è la parte che la consegna chiede per prima: **quello che i nostri referti
attribuiscono a questa live è davvero quello che la live dice?**

Fonti nostre messe a confronto:
- `mql5/Experts/ABTG_Nasdaq_Live5m.mq5` **r.1-38** (l'intestazione, che è l'atto di
  nascita: *«variante basata sulla LIVE del 17/07/26»*);
- `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` **r.43-56** (che cita
  quell'intestazione) e **r.172**, **r.496-497**;
- `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md` **r.70-74** e **r.332-341**.

| # | Cosa ATTRIBUIAMO alla live | Cosa dice DAVVERO la trascrizione | Esito |
|---|---|---|---|
| **A** | *«candela TRIGGER = i 5 minuti PRIMA dell'apertura (15:25-15:30 IT)»* | **r.19**: *«la strategia del Nasdaq la applichiamo dalle ore 15.25 alle 15.30»* · **r.21**: *«il massimo e il minimo della candela che è dalle 15.25 alle 15.30»*, con **`Nasdaq che è posizionato con un time frame a 5 minuti`** | ✅ **CONFERMATO ALLA LETTERA** |
| **B** | *«ordini a 7 punti indice oltre max/min (buffer 700)»* | **r.23**: *«io piazzerò un ordine pendente alle ore 15.30, **sette punti sopra long e sette punti sotto short**»* · **r.27**: *«l'ordine lo posiziono a sette punti»* · **r.65**: *«venti contratti distanti, **sette punti**, dal minimo di questa candela»* · **r.71**: *«Questo lo devo mettere a sette punti, **solo sette punti**»* | ✅ **CONFERMATO, quattro volte** |
| **C1** | *«opera solo se la candela è ≥ 17 punti indice (MINRANGE 1700)»* | **r.21**: *«la candela deve essere **superiore a 17 points, 17 punti**»* | ✅ **CONFERMATO.** ⚠️ Micro-scarto dichiarato: la fonte dice *«superiore a»* (17 escluso), il nostro `InpMinRangePts=1700` ammette **esattamente 17,00**. **Un punto indice, irrilevante nei fatti — ma è una derivazione, non una citazione** |
| **C1-bis** | 🟢 **la RAGIONE del pavimento** (mai citata nei referti) | **r.21**: *«Perché il rischio di essere preso **su e giù** diminuisce del **40 per cento**»* | 🆕 **DATO NUOVO** — [DICHIARATO, NON verificato]. È l'unica giustificazione quantitativa che la fonte dà a un suo filtro |
| **C2** | *«opera solo se la candela è ≤ 40 punti indice (MAXRANGE 4000), **come da live**»* | 🔴 **La live NON dice mai "40 è il tetto".** Dice **r.61**: *«questa è una **cannella da 40 punti**, io a **41 punti ho il divieto** di fare l'operazione da mio piano di trading»* | 🟠 **ARITMETICAMENTE CORRETTO, MA DERIVATO.** Divieto **a 41** ⇒ ammesso **fino a 40** ⇒ `MAXRANGE 4000` è giusto. 🔴 **Ma il commento del codice dice *«come da live»* e la live il 40 non lo pronuncia**: lo pronuncia come *ampiezza della candela di oggi*, e il 41 come *soglia del divieto*. **La conclusione regge, la citazione no** |
| **D** | *«stop all'estremo opposto della candela»* | **r.27**: *«Una volta che mi prende il mio ordine, il mio stop lo metterò **sopra il massimo**»* (detto mentre descrive l'ingresso SHORT sotto il minimo) | ✅ **CONFERMATO** |
| **E** | *«1 trade/giorno» (`InpOneTradePerDay=true`)* | 🔴 **La live NON lo dice, e fa il CONTRARIO.** **r.91**: *«Ora gli ordini short alla rottura in questo caso io li tengo... **questa è un altro tipo di strategia**»* · **r.93**: *«**Seconda strategia**, alla rottura del minimo, e io questo lo faccio in scalping, **entro**»* · e a **r.11** programma anche un trade sull'oro nella stessa sessione | 🔴 **NON CONFERMATO — è una NOSTRA scelta**, legittima ma **non attribuibile alla fonte**. Va scritto così, non *«come da live»* |
| **F** | 🔴 *«il target a PUNTI FISSI (+50) non esiste in casa: è l'unico ingrediente davvero **VERGINE** dell'EA esterno»* (`PREOPEN_NASDAQ_VALE_UN_POSTO` r.172; idem r.496-497 *«**sostituisce** il target in R con un target a punti FISSI»*; `AUDIT` r.341 *«L'EA esterno **lo sostituisce** con +20 punti fissi»*) | 🔴 **FALSO NELLA PROVENIENZA.** **r.67**: *«Qual è il target? **Target minimo 50 punti**, minimo, minimo 50 punti»* · **r.83**: *«io **metà posizione dopo 20 punti** la porto a casa, **stop in pari** e adios amigos»* | 🔴 **DIFETTO NOSTRO.** Il +20/+50 a punti fissi **è la ricetta della live**. L'EA esterno non «sostituisce» niente: **copia la fonte**. 👉 **È il NOSTRO `Live5m` che ha deviato**, mettendo `InpTP1_R=1` (obiettivo in **R**, ancorato allo stop). ⚖️ Il **giudizio di merito** del 12/09 (target fisso su stop variabile = geometria peggiore) **non cambia**: cambia **di chi è la colpa**, e cambia il fatto che *«vergine»* era sbagliato |
| **G** | *«% chiusa al primo obiettivo = 50»* (`InpTP1_ClosePct=50`) | **r.83**: *«**metà posizione** dopo 20 punti la porto a casa»* · **r.111**: *«L'incasso io il **50%** me lo porto a casa»* | ✅ **CONFERMATO, due volte** |
| **H** | ⚠️ *«NON include l'hedging "Piano B/C" della live (aggiunta di size in perdita): è la parte che causa i grossi drawdown»* (intestazione EA, r.16-17) | **r.57-59** descrivono esattamente quel meccanismo · **r.153**: *«Durante un corso di scalping ho perso **1.400.000 euro**... **Questa è un'operazione edgata**»* | ✅ **CONFERMATO — e la fonte lo conferma CONTRO SÉ STESSA.** L'esclusione fatta a luglio era giusta, e oggi ha la citazione sotto |
| **I** | *`InpSessionHour=14` / `InpSessionMin=30` (= 15:30 IT = 14:30 server BCM)* | 🟢 **La trascrizione verifica il fuso DA SOLA, due volte**: **r.21** *«siano le **14.08**, quindi in realtà sono le **15.08**»* e **r.59** *«sono le **14.25** quindi mi preparo per la mia operatività»* (mentre aspetta la candela che lui chiama 15:25-15:30) | ✅ **CONFERMATO da DUE punti indipendenti dentro la fonte.** L'orologio della sua piattaforma è **ora italiana − 1**, cioè **lo stesso offset di BCM**. Quindi *«15:25-15:30»* nel suo parlato è **ora italiana**, e la candela server è **14:25-14:30**: esattamente ciò che il nostro preset scrive. **[INFERITO da r.21 + r.59, alta confidenza]** |

## 1.1 🔴 LA CORREZIONE PIÙ GROSSA — **e non è nei referti: è nella consegna di oggi**

La consegna dice: *«La live detta la strategia d'apertura Nasdaq coi numeri, ed è la
nostra sedia `770260`»*.

### 🔴 **NO. `770260` NON È LA SEDIA DI QUESTA LIVE.** Letto nei due preset, riga per riga:

`mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set` (BCM) e la copia rimappata
`mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`:

| input | valore in `770260` | cosa vuol dire | la live dice |
|---|---|---|---|
| `InpRangeMode` | **0** = `ABTG_RANGE_OPENING` (`ABTG_Nasdaq_Apertura_US.mq5` r.176) | range = primi N minuti **DOPO** l'apertura | 🔴 **PRIMA** dell'apertura (r.19) |
| `InpRangeMinutes` | **35** | il range dura **35 minuti** | 🔴 **5 minuti** (r.19) |
| `InpEntryMode` | **2** = `ABTG_RETEST` (r.151) | rottura + **ritorno sul livello con LIMIT** | 🔴 pendente **STOP** a 7 punti oltre (r.23) |
| `InpBufferPoints` | **200,0** → su `NASUSD` (`_Digits=2`) = **2,0 punti indice** | | 🔴 **7 punti** (r.23) |
| `InpMinRangePts` | ✅ **0.0** | pavimento **SPENTO** | 17 punti (r.21) |
| `InpMaxRangePts` | ✅ **0.0** | tetto **SPENTO** | divieto a 41 punti (r.61) |
| `InpTP1_ClosePct` | **0.0** | **nessun parziale** | 🔴 **50%** (r.83, r.111) |

👉 **`770260` è `ABTG_Nasdaq_Apertura_US` sul range dei 35 minuti DOPO l'apertura,
con ingresso a RETEST.** La sedia di QUESTA live è **`ABTG_Nasdaq_Live5m`, magic
`770203`** — che non è in campo, ed è **morta a tick reali** (`REGISTRO_TEST.md`
riga L2: **PF OOS 0,96265 · n 175 deal · DD 19,40% · −326,54 €**, 27/27 combo negative).

✅ **La verifica che la consegna chiedeva è comunque CONFERMATA:
`InpMinRangePts=0.0` e `InpMaxRangePts=0.0`** in tutti e due i file di `770260`
(BCM **r.89-90** · copia FTMO **r.132-133**). Lettura di Claudio: **giusta**.

## 1.2 🔎 IL TETTO DEI 41 PUNTI: **c'è o non c'è nel repo?** — grep fatto, risposta netta

Cercato in tutto `mql5/` e in tutto `report/` (esclusi i worktree degli agenti):

| cosa ho cercato | esito |
|---|---|
| il numero **41** / **4100** come soglia d'ampiezza | 🔴 **ZERO occorrenze.** Gli unici `41` nel repo sono un DD del DAX, un magic `784100` e una costante di Lyapunov |
| il tetto **come 40 punti indice** (`MAXRANGE 4000`) | 🟢 **C'È, in TRE posti**: `mql5/Experts/ABTG_Nasdaq_Live5m.mq5` **r.36** (`#define ABTG_DEF_MAXRANGE 4000 // candela <= 40 punti indice (live)`) · `mql5/Experts/ABTG_DAX_Live5m_v2.mq5` **r.33** (`// FILTRO: candela <= 40 punti (niente candeloni da news)`) · `mql5/Presets/ABTG_Nasdaq_Live5m.set` **r.21** (`InpMaxRangePts=4000`) |
| la **manopola** `InpMaxRangePts` | 🟢 esiste in **10 EA** di `mql5/Experts/` + **4 copie** in `standalone/` + il motore condiviso `mql5/Include/ABTG/ABTG_ApertureCore.mqh` (fra gli altri: `Nasdaq_Apertura_US` r.222, `Nasdaq_Apertura_US_Ottimizzato` r.189, `Dow_Apertura_US` r.243, `Apertura_3Ingressi` r.269, `Live5m` r.190) e in **12 preset** di `mql5/Presets/` |
| il tetto **acceso** in un preset | 🔴 **UNO SOLO su 12**: `ABTG_Nasdaq_Live5m.set` (la sedia morta). In **tutti** gli altri è `0.0` = spento |

### ✅ Verdetto: **il tetto NON ci manca — ce l'abbiamo, è al valore giusto, ed è sulla sedia giusta (quella morta).** Sulla `770260` è spento, e **fa bene a esserlo.** Il perché è nel §1.3, ed è un numero, non un'opinione.

## 1.3 🧮 **IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO ME STESSO** — *«e se accendessimo 17-40 sulla `770260`?»*

L'ipotesi tentatrice, formulata **prima** di guardare i numeri:
> *«La fonte dichiara una banda 17-40. Noi abbiamo la manopola spenta su una sedia
> viva in challenge. Accendiamola: è gratis.»*

**Se fosse una buona idea**, la banda dovrebbe tagliare una frazione sensata delle
giornate. **Misura, dal nostro archivio** —
`backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`,
colonne `up30_pt`/`dn30_pt`, numeri già estratti e pubblicati in
`report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` §2.3:

| anno | n giornate | **mediana del range dei primi 30 minuti** (punti indice) |
|---|---:|---:|
| 2022 | 258 | **120,3** |
| 2023 | 158 | **80,0** |
| 2024 | 258 | **86,4** |
| 2025 | 255 | **116,6** |
| 2026 (a lug) | 145 | **176,6** |

Il range della `770260` dura **35 minuti**, quindi è **≥** di questi valori.

### 🔴 **LA BANDA DELLA FONTE NON SI TRASPORTA: un tetto a 40 punti indice su un range da 35 minuti spegnerebbe la sedia.**
La mediana del range a 30 minuti è fra **80 e 177** punti indice — cioè fra **2,0x e
4,4x** il tetto. Un `InpMaxRangePts=4000` rifiuterebbe **la stragrande maggioranza**
delle giornate; un `InpMinRangePts=1700` sarebbe **inerte** (quasi tutte le giornate
lo superano di 5-10 volte). 👉 **La banda 17-40 è tarata su una candela da CINQUE
minuti. Copiarla su un range da TRENTACINQUE è un errore di scala, non un
miglioramento** — ed è esattamente il punto che `report/PREOPEN_GEMELLI_LA_SCALA_2026-09-13.md`
aveva congelato in titolo: **«la scala NON si deriva, si MISURA»**.

🟢 **E c'è una misura di casa che dice che il cancello, ALLA SCALA GIUSTA, morde nel
verso buono**: sul gemello DAX a 5 minuti, accendere il cancello a **15-40** ha
portato il PF OOS da **0,857** (spento, n 342) a **0,925** (acceso, n 202)
— `PREOPEN_GEMELLI_LA_SCALA` r.55-58. Non basta per 1,10, **ma il meccanismo è sano.
È il trasporto che è rotto.**

---

# 2. 📋 LA SCHEDA — la griglia di casa, compilata

```
FILE            trascrizioni/LIVE_EMILIANO_2026-07-17_APERTURA_NASDAQ.txt (193 righe)
RELATORE        Emiliano Monza (r.117 "Emiliano Monza, questo e'"; r.131 "Mignano
                Monza" = storpiatura; r.165 "Emiliano Monza e' il mio brand";
                r.151 "Conto Emiliano Monza"). Presenti: Luca (assistente, r.3),
                platea a webinar. [TRASCRITTO chiaro]
OGGETTO         (1) strategia d'apertura NASDAQ sulla candela M5 pre-apertura;
                (2) piano B/C di hedging e recupero; (3) strategia ORB;
                (4) esibizione di equity line e metriche personali.
BROKER          r.151: "conto Real, Edge, sono sui serve di BCM" -> dichiara di
                operare su BCM, LO STESSO BROKER NOSTRO. "Edge" e' [TRASCRITTO
                dubbio] (tipo conto? nome? non ricostruibile).
```

## 2.1 📐 PARAMETRI CON VALORE — **26**, tutti con citazione

| # | parametro | valore | citazione | riga | etichetta |
|---|---|---|---|---|---|
| P1 | candela trigger | **15:25→15:30**, TF **M5** | *«la strategia del Nasdaq la applichiamo dalle ore 15.25 alle 15.30»* · *«Nasdaq che è posizionato con un time frame a 5 minuti»* | r.19, r.21 | 🟢 [TRASCRITTO chiaro] |
| P2 | buffer d'ingresso | **7 punti** sopra il max / sotto il min | *«sette punti sopra long e sette punti sotto short»* | r.23, r.27, r.65, r.71 | 🟢 [TRASCRITTO chiaro, 4 ripetizioni] |
| P3 | pavimento d'ampiezza | candela **> 17 punti** | *«la candela deve essere superiore a 17 points, 17 punti»* | r.21 | 🟢 [TRASCRITTO chiaro, detto 2 volte] |
| P4 | ragione del pavimento | rischio di whipsaw **−40%** | *«il rischio di essere preso su e giù diminuisce del 40 per cento»* | r.21 | 🟠 [DICHIARATO, NON verificato] |
| P5 | **tetto d'ampiezza** | **divieto a 41 punti** | *«questa è una cannella da 40 punti, io a 41 punti ho il divieto di fare l'operazione da mio piano di trading»* | r.61 | 🟢 [TRASCRITTO chiaro] |
| P6 | ragione del tetto | *«perché lo stop è troppo ampio»* | *«Perché lo stop è troppo ampio, perché lo stop è troppo ampio, perché qua si entro con 50 o 100 contratti, qua sono 40.000 euro di stop»* | r.61 | 🟢 [TRASCRITTO chiaro] |
| P7 | stop | **estremo opposto** della candela | *«il mio stop lo metterò sopra il massimo»* | r.27 | 🟢 [TRASCRITTO chiaro] |
| P8 | target | **minimo 50 punti** | *«Target minimo 50 punti, minimo, minimo 50 punti»* | r.67 | 🟢 [TRASCRITTO chiaro] |
| P9 | parziale | **metà posizione a +20 punti**, poi **stop in pari** | *«io metà posizione dopo 20 punti la porto a casa, stop in pari e adios amigos»* | r.83, r.111 | 🟢 [TRASCRITTO chiaro] |
| P10 | size piena del giorno | **50 contratti** (*«di solito entro con 100»*) | *«il conto me lo permette, con 50 contratti sul Nasdaq»* · *«Di solito entro con 100, lo faccio con 50»* | r.29, r.31 | 🟢 [TRASCRITTO chiaro] |
| P11 | size contro trend | **metà** | *«siccome sono contro trend io tendenzialmente sono abituato a mettere in metà dei contratti»* | r.49, r.55 | 🟢 [TRASCRITTO chiaro] |
| P12 | size fuori banda (oggi) | **10 → poi 20** contratti | *«entrerò con 10 contratti... potrei farne anche 20... Quindi entro con 20 contratti»* | r.61, r.63, r.65 | 🟠 [TRASCRITTO chiaro ma **contraddittorio in 3 righe**: 10, poi 20, poi 20] |
| P13 | size seconda operazione | **100 contratti** | *«qua entro come Dio comanda... questa è un'operazione da 100 contratti»* | r.91 | 🟢 [TRASCRITTO chiaro] |
| P14 | obiettivo del giorno | **189 punti** di distanza | *«L'obiettivo dista 189 punti»* | r.41 | 🟢 [TRASCRITTO chiaro] |
| P15 | movimento pre-apertura | **600 punti** di candela | *«sono 600 punti di candela, 600 punti»* | r.47 | 🟢 [TRASCRITTO chiaro] |
| P16 | durata attesa del trade | *«pochi secondi, massimo un minuto»* · *«nei primi cinque minuti... nei primi due minuti»* · *«dopo 7 minuti»* | r.65, r.89, r.121-123 | 🟠 [TRASCRITTO chiaro, ma **tre numeri diversi**] |
| P17 | **ORB apertura USA** | candela da **30 minuti** | *«nella prima mezz'ora di notazione americana, stai fermo... con la candela a 30 minuti»* · *«all'apertura americana a 30 minuti»* | r.165, r.169 | 🟢 [TRASCRITTO chiaro] |
| P18 | **ORB apertura europea** | candela da **15 minuti** | *«Io all'apertura europea l'utilizzo a 15 minuti»* · *«scelgo il time frame a 15 minuti alla mattina»* | r.169, r.179 | 🟢 [TRASCRITTO chiaro] |
| P19 | ORB a 5 minuti | **sconsigliato la mattina** | *«prendete il 15 e fidatevi di me perché il 5 dà troppi falsi segnali»* | r.179 | 🟢 [TRASCRITTO chiaro] |
| P20 | medie dell'ORB | **EMA 9 e 21** (si corregge in diretta da «20 e 9») | *«devo inserire la 20 e la 9, o la 21 e la 9. E mi correggo, in tempo reale 21 e 9»* · *«medie esponenziali»* | r.171, r.177, r.183 | 🟢 [TRASCRITTO chiaro, con autocorrezione esplicita] |
| P21 | conferma volumi | **volumi in crescita** alla rottura | *«l'ultima informazione necessaria è che i volumi siano in crescita in prossimità della rottura del livello»* | r.179, r.183 | 🟢 [TRASCRITTO chiaro] · ⚠️ **nessun moltiplicatore dettato** (il nostro 1,5 non viene da qui) |
| P22 | conferma d'apertura | la candela deve **aprire oltre** il livello | *«quando aprendo la candela sopra l'orb, col culettino sopra il mio valore di riferimento... allora rientro»* | r.185 | 🟢 [TRASCRITTO chiaro] |
| P23 | ingresso a **RETEST** | se apre distante, si aspetta il ritorno | *«lascio andare ma mi posiziono sul retest... la parte di ciccia la metto sul retest»* | r.185 | 🟢 [TRASCRITTO chiaro] |
| P24 | stop dell'ORB | **sotto il VWAP** se c'è; **sotto il minimo dell'ORB** se non c'è | *«Se io ho sotto il wrap lo stop lo metto sotto il wrap... se non ho il wrap lo stop lo metto sotto il minimo precedente cioè il minimo dell'orb»* | r.187 | 🟠 *«wrap»* = **VWAP** [INFERITO da r.177 *«il mio VRAP... basato sulla volatilità»*] |
| P25 | modello DAX (non usato oggi) | Bollinger **«37,3»**, Supertrend, medie **200/100/21/9** | *«Le Bollinger Bands sul DAX ho una configurazione particolare 37,3»* · *«ho le medie mobili 200, 100, 21 e 9»* | r.17, r.19 | 🔴 **«37,3» [TRASCRITTO dubbio]**: può essere periodo 37 dev 3, oppure 3,7, oppure due numeri separati. **NON interpretato** |
| P26 | profondità dei backtest | **26 anni** / *«oltre 25 anni»* | *«lo do backtestato su ormai 26 anni di esperienza... su oltre 25 anni di backtest»* | r.189 | 🟠 [DICHIARATO, NON verificato] |

## 2.2 ⚙️ MECCANISMI — **13**

| # | meccanismo | come lo descrive | riga |
|---|---|---|---|
| M1 | **direzione PRIMA di tutto** | *«la prima cosa è la direzione»* · *«la direzione si individua prima studiando il weekly»* → poi daily → poi il livello | r.33, r.35, r.47 |
| M2 | supporti/resistenze *«da trader»* | *«si tracciano in questa maniera unendo massimi e minimi contrapposti»* | r.43, r.45 |
| M3 | **apertura «col culettino»** sopra/sotto il livello = segnale | *«se la candela successiva mi apre sopra o sotto col culettino... quello è un segnale palesemente short»* | r.47 |
| M4 | **imbalance** da coprire | *«questa candela è una candela di imbalance pesante, cioè questa candela deve essere totalmente coperta»* | r.49 |
| M5 | obiettivo ancorato a **«tre minimi di pre-section»** | *«su questi tre minimi... sono tre minimi che vanno a determinare il mio obiettivo»* | r.39, r.41 | 
| M6 | **correlazione** fra indici | tiene aperti S&P, US30, DAX: *«guardate l'SMP, l'SMP continua a scendere»* · *«abbiamo US che si è messo long, S&P che è short»* | r.13, r.63, r.69, r.93 |
| M7 | **piano A / B / C scritto PRIMA** | *«quando sono nella BIP, lì subentra l'emotività e le decisioni, se non sono già prese prima, vengono prese a BIP»* | r.51-59 |
| M8 | 🔴 **hedging** | *«a quel punto io sono eggiato con una perdita»* · *«mi troverò nella situazione di hedging»* | r.51, r.63 |
| M9 | 🔴 **scale-in di recupero** sul lato del trend | *«io metto dopo lo short altri 50 contratti... questa parte me la recupero andando a valorizzare con il doppio della size»* | r.57, r.59 |
| M10 | **riduzione size** su tre assi | pomeriggio (*«al pomeriggio di solito diminuisco le sites»*, r.49), contro trend (metà, r.49/55), fuori banda (r.61) | r.49, r.55, r.61 |
| M11 | parziale 50% + **stop in pari** | *«metà posizione dopo 20 punti la porto a casa, stop in pari»* | r.83 |
| M12 | **ORB a tripla conferma** | (a) massimo/minimo della candela 30' · (b) medie 9/21 incrociate e inclinate nella direzione · (c) volumi in crescita | r.179, r.183 |
| M13 | **VWAP proprietario** come supporto dinamico e **ancora dello stop** | *«un wrap che nessuno al mondo ha perché l'ho costruito io e l'ho costruito sulla base della volatilità»* | r.177, r.187 |

## 2.3 🏦 REGOLE PROP CITATE — **ZERO**

🔴 **In 193 righe non compare NESSUNA menzione di**: prop firm, challenge, FTMO,
funded, limite di perdita giornaliero, muro statico, consistency rule, drawdown
massimo consentito, regole sugli EA. **Ricerca fatta sul testo intero.**

👉 **Questo materiale non dice niente sul nostro problema principale.** Opera su un
conto proprio, senza muri esterni — ed è esattamente il contesto in cui i
meccanismi del §2.5 sono possibili. **Il valore prop di questa live è ZERO in
positivo e alto in negativo** (ci dice cosa NON fare).

## 2.4 📊 NUMERI DI PERFORMANCE — tutti **[DICHIARATO, NON verificato]**

| numero | citazione | riga |
|---|---|---|
| **+56.000 €** stamattina | *«parto da un risultato di più 56 mila euro»* · *«ho fatto 56k»* | r.5, r.49 |
| **85.000 €** ieri sera in live | *«ieri sera in live 85k»* | r.49 |
| **~100.000 €** mercoledì | *«mercoledì circa 100»* | r.49 |
| **92-93%** di giornate positive la **mattina** · **68-70%** il **pomeriggio** | *«la mia percentuale di profitabilità rispetto al mattino, del 92-93 per cento, quindi su 100 mattinate sette richiude negativo, al pomeriggio sono circa 68-70 per cento»* | r.49 |
| **2.111.000 €** da un deposito di **20.000 € + 10.000 di credito** | *«2.111.000 euro con un deposito di 20.000 e 10.000 di credito»* | r.145 |
| periodo: **30/04/2026 → «17 agosto»** | *«è partito il giorno 30 aprile 2026, ripeto 30 aprile 2026, al 17 agosto»* | r.145 | 
| **1.700.000 €** l'anno scorso | *«Scorso anno ho fatto 1.700.000»* | r.147 |
| **oltre 8.000 operazioni** | *«ho fatto più di 8.000 operazioni»* | r.149 |
| 🔴 **−1.400.000 €** in un corso di scalping | *«Durante un corso di scalping ho perso 1.400.000 euro»* | r.153 |
| 🔴 **−500.000 €** in una mattina | *«ho perso alla mattina 500.000 euro»* | r.155 |
| **+650.000 €** di recupero nel pomeriggio | *«nel pomeriggio davanti a tutti ho fatto quasi 650.000 euro»* | r.157 |
| 🔴 **Profit Factor: da 2,7 a 1,20** | *«il mio profit factor lo scorso anno era di 2.7 e adesso sono 1.20»* | r.159 |
| 🔴 **operazioni in profitto: da 80% a 62%** | *«solo il 62 per cento perché io di solito ho l'ottanta per cento»* | r.159 |
| **−293.000 €** e **−172.000 €** (singole operazioni/tratti) | *«ho perso 293 mila euro, cazzo Emi, ho perso 172»* | r.143 |
| **−200.000 €** (conto bruciato, storico) | *«ho bruciato 200 mila euro che era tutto il patrimonio che avevo»* | r.189 |
| risultato di oggi: **80 punti Nasdaq** | *«sono 80 punti Nasdaq. 80 punti Nasdaq»* | r.129 |
| a metà trade: **2.700 € / 35 punti** | *«qua siamo a 2700 euro e abbiamo fatto già 35 punti Nasdaq»* | r.99 |

⚠️ **Il «17 agosto» di r.145 è incoerente con la data della live (17/07/2026)**:
o è un errore di trascrizione per *«17 luglio»*, o il conto è mostrato in una
registrazione successiva. **[TRASCRITTO dubbio] — non usato per nessun calcolo.**

⚠️ **Nota di coerenza interna, che va detta**: il conto passa da **20.000** a
**2.111.000** (105x) in **~2,5 mesi**, con **8.000+ operazioni** e un **PF
dichiarato 1,20**. Un PF di 1,20 con 8.000 operazioni è compatibile con una crescita
enorme **solo** se la size cresce col capitale (capitalizzazione composta aggressiva)
— che è coerente con i drawdown dichiarati di 500k-1,4M. **Non è una verifica: è una
lettura di coerenza, e va etichettata [INFERITO].**

## 2.5 🚩 BANDIERE ROSSE — **10**, di cui **4 NON ADOTTABILI su conto prop**

| # | bandiera | la citazione che lo prova | riga | verdetto |
|---|---|---|---|---|
| **B1** | 🔴 **HEDGING** (posizioni opposte sullo stesso strumento) | *«A quel punto io sono **eggiato** con una perdita»* · *«molto probabilmente mi troverò nella situazione di **hedging**»* · *«devo assolutamente **eggiarmi** a metà canale»* · *«Questa è un'operazione **edgata**... ma è stato **edging**»* | r.51, r.63, r.59, r.153 | 🔴 **NON ADOTTABILE.** Il nostro EA di riferimento lo esclude **per scritto** (`ABTG_Nasdaq_Live5m.mq5` r.16-17), e la fonte stessa lo lega al DD da 1,4 M€ (r.153) |
| **B2** | 🔴 **PIANO B: +50 contratti su una posizione in perdita** | *«il piano B è sono filato long, 50 contratti, mi si gira, va in direzione dello short, io metto dopo lo short **altri 50 contratti**... questa parte me la recupero andando a valorizzare con **il doppio della size**»* | r.57, r.59 | 🔴 **NON ADOTTABILE.** È aumento d'esposizione a perdita in corso: il muro giornaliero prop non perdona un recupero |
| **B3** | 🔴 **PIANO C: 100 contratti a metà canale** | *«devo assolutamente eggiarmi a metà canale, cioè a metà canale vedrete me che metterò degli ordini cioè **50 più 50 cento** voltanti perché qua diventa una perdita troppo onerosa»* | r.59 | 🔴 **NON ADOTTABILE.** Raddoppio del raddoppio, dichiarato *«raramente»* ma pianificato |
| **B4** | 🔴 **SIZE ERRATICA nella stessa sessione: 10 → 20 → 50 → 100** | r.61 *«entrerò con 10 contratti»* → r.61 *«Quindi entro con 20 contratti»* → r.49 *«l'ordine short lo metterò con la size piena, 50 contratti»* → r.91 *«questa è un'operazione da **100 contratti**»* | r.29-31, r.49, r.61, r.91 | 🔴 **NON ADOTTABILE su FTMO**, e il motivo è già scritto in casa nostra: la **copia FTMO** del preset `770260` (`mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` **r.167-168**) cita le **Forbidden Practices** — *«substantially larger or smaller position sizes»* — ed è la ragione per cui **la nostra taglia è UNIFORME su tutte le sedie**. Un rapporto **10:1** nella stessa sessione è esattamente ciò che la regola vieta |
| **B5** | 🔴 **operare VIOLANDO il proprio piano, dichiarandolo** | *«io a 41 punti ho il divieto di fare l'operazione da mio piano di trading, però sono in live, cosa faccio? Diminuisco le size **perché voi volete vedere il sangue e il sangue vi darò** ok?... il mio piano di trading prevede di **stare fermo**»* | r.61 | 🔴 **Il passaggio integrale è al §2.6.** Non è adottabile né come pratica né come esempio: la fonte dichiara che la ragione dell'operazione è **lo spettacolo** |
| **B6** | 🔴 **override discrezionale della regola appena dettata** | r.83 detta: *«metà posizione dopo 20 punti la porto a casa»*. r.101 la rompe: *«Io volevo chiudere a metà posizione, portare a casa a metà profitto, **però per me questo scende e adesso sto in posizione**»* | r.83 vs r.101 | 🔴 **La regola e la sua violazione distano 18 righe.** Chi copia il metodo copia anche questo |
| **B7** | 🔴 **drawdown dichiarati fuori scala** | *«ho perso **1.400.000 euro**»* · *«ho perso alla mattina **500.000 euro**»*, su un conto partito da **20.000** (r.145) | r.145, r.153, r.155 | 🟠 **[DICHIARATO]**. Su una challenge FTMO 100k con muro giornaliero al 5% e statico al 10%, **una sola** di quelle giornate chiude il conto |
| **B8** | 🔴 **metriche in PEGGIORAMENTO, dichiarate dalla fonte** | *«il mio profit factor lo scorso anno era di 2.7 e adesso sono **1.20**... solo il **62 per cento** perché io di solito ho l'**ottanta per cento**»* | r.159 | 🟠 **[DICHIARATO]**. Va registrato: **la fonte stessa dice che il suo edge si sta degradando** |
| **B9** | 🔴 **filosofia della perdita incompatibile col muro prop** | *«le operazioni le chiudo anche con **500 mila euro di perdita**... la chiudo perché se io sono sul mercato e ho ancora soldi io li ho recuperati al pomeriggio, ma li avrei potuti recuperare anche due settimane, tre settimane»* | r.191 | 🔴 **In una prop non esistono "tre settimane per recuperare": esiste il muro GIORNALIERO.** È il punto in cui questo modello e il nostro sono incompatibili per costruzione |
| **B10** | 🟠 framing da azzardo / onnipotenza | *«qua la **slot machine** ti dà da guadagnare adesso»* · *«Gli indici fanno quello che dice Mignano Monza»* | r.97, r.131 | 🟠 Non è un meccanismo, è un **avviso sul peso da dare al resto** |

### 🟢 LE ASSENZE VERIFICATE — *come si fa in casa*

| meccanismo cercato | nella TRASCRIZIONE | nel NOSTRO codice derivato (`ABTG_Nasdaq_Live5m.mq5`) |
|---|---|---|
| **martingala** | 🟢 **ZERO occorrenze della parola.** ⚠️ **Ma il meccanismo di r.57-59 va nominato per quello che è**: la fonte dice testualmente *«mi recupero andando a valorizzare con **il doppio della size**»*. **Non è la martingala classica** (nessun raddoppio geometrico per perdita consecutiva): è **hedge + scale-in di recupero**. Lo dichiaro così, senza gonfiarlo | 🟢 **0 occorrenze** (`grep martingal` = 0) |
| **griglia / grid** | 🟢 **ZERO.** Nessun reticolo di ordini a distanza fissa | 🟢 **0 occorrenze** di `grid`/`Grid`; **1** di *«griglia»*, in un commento sull'ottimizzatore |
| **recovery / recovery zone** | 🟢 **ZERO come parola.** Il concetto c'è in B2/B3 | 🟢 **2 occorrenze**, ma sono `TesterStatistics(STAT_RECOVERY_FACTOR)` (r.1221) e il suo commento (r.1225): **è una METRICA del tester, non un meccanismo di recupero.** Nessun recovery nel codice |
| **trading senza stop** | 🟢 **ASSENTE — anzi, il contrario.** Lo stop c'è **sempre**: r.27 *«il mio stop lo metterò sopra il massimo»* · r.57 *«l'ordine di stop lo metto dopo tutte e due le ordini»* · r.79 *«il mio stop è subito dopo gli ordini»* · r.83 *«stop in pari»* · r.187 *«lo stop lo metto sotto il wrap»* | 🟢 `InpSLMode` sempre valorizzato, stop calcolato in `OrderSend` (r.661, r.678) |
| **anti-rilevamento prop / mascheramento EA** | 🟢 **ZERO.** Nessun accenno a eludere controlli di prop firm | — |

🟢 **Quattro assenze su cinque sono NETTE**, e la quinta (martingala) è **nominata
correttamente invece che gonfiata**. Questo è un materiale **discrezionale e
aggressivo**, non un materiale **truffaldino**.

## 2.6 📜 IL PASSAGGIO INTEGRALE CHE LA CONSEGNA CHIEDE — **r.61, la violazione in diretta**

> *«C'è una cosa che vi ho detto, io vado a vedere sempre la correlazione anche
> ragazzi, nasdaq pesante qua, **questa è una cannella da 40 punti, io a 41 punti ho
> il divieto di fare l'operazione da mio piano di trading, però sono in live, cosa
> faccio? Diminuisco le size perché voi volete vedere il sangue e il sangue vi darò
> ok? Perché qua io ho il divieto da piano trading, ho il divieto, perché ho il
> divieto l'avete capito? Perché Vincenzo Catteddu? Perché? Perché lo stop è troppo
> ampio, perché lo stop è troppo ampio, perché qua si entro con 50 o 100 contratti,
> qua sono 40.000 euro di stop e se mi fa avanti indietro cosa faccio? Sui primi 5
> minuti mi brucia 100.000 euro? No, allora ragazzi solo perché sono in live, perché
> il mio piano di trading prevede di stare fermo, entrerò con 10 contratti** che non
> mi cambiano assolutamente niente a livello operativo, 10 contratti sono solo uno
> stop di 10 contratti con una candela di 500 euro, potrei farne anche 20, non mi
> cambiano, però non posso mettere a rischio i soldi che ho guadagnato stamattina.
> **Quindi entro con 20 contratti.** Allora, questo può essere considerato il minimo
> della candela? Molto probabilmente sì, mancano ormai tre minuti, molto probabile
> che questo è il minimo definitivo della candela a cinque minuti, quindi vado a
> tracciare il mio livello, questo qua, e **vado già a piazzare questa operazione
> molto rischiosa per diversi motivi**.»*

E il seguito immediato, **r.63**:

> *«Poi ve li dico, traccio il minimo, quindi **il mio piano prevede di non entrare,
> lo sto facendo perché è giusto che per la prima volta mi state vedendo tutti**, ho
> tante persone nuove e quindi mi sembra giusto farvi vedere esattamente come
> tralavora un trader e quindi **molto probabilmente mi troverò nella situazione di
> hedging**, molto probabilmente, e vi farò vedere come l'utilizzo.»*

### 🔎 Cosa ne estraiamo davvero, al netto dello spettacolo
1. 🟢 **Il tetto esiste ed è motivato con un CONTO**: *«lo stop è troppo ampio... qua
   sono 40.000 euro di stop... Sui primi 5 minuti mi brucia 100.000 euro?»*. È la
   **stessa logica del nostro cancello di costo** (`stop ≥ 40 × spread` letto
   dall'altro verso: uno stop troppo largo rende il trade non sostenibile).
   **Convergenza di ragionamento, su una fonte indipendente.**
2. 🔴 **La violazione è motivata dallo SPETTACOLO**, non dal mercato: *«perché voi
   volete vedere il sangue»*. **Non è un'eccezione tecnica di cui imparare la regola:
   è rumore, e va scartato.**
3. 🟠 **La mitigazione scelta — ridurre la size — è esattamente la B4**: per una prop
   è una violazione, non una protezione.

## 2.7 🖥️ COSA C'ERA A SCHERMO E NON NEL PARLATO — **le domande per Claudio**

| # | cosa è mostrato e NON dettato | riga | perché lo vogliamo |
|---|---|---|---|
| S1 | il **pannello delle metriche** del conto (dove legge PF 1,20 e 62%) | **r.159** *«Queste sono le mie metriche»* | è l'unico posto dove si vedrebbero n, DD, expectancy veri accanto al PF. **Screenshot al minuto del r.159** |
| S2 | la **equity line** completa | **r.151-157** *«Questa è la mia equity line»* | il DD da 1,4 M€ è letto **a occhio** dal grafico: la forma direbbe se è un evento o una serie |
| S3 | i **settaggi delle Bollinger «37,3»** sul DAX | **r.17** | il numero è [TRASCRITTO dubbio] e **senza screenshot resta indecifrabile** |
| S4 | il **calcolatore di size/stop** da cui esce *«40.000 euro di stop»* | **r.61** | dice il valore-punto del suo contratto: **senza quello, "50 contratti" non è convertibile in rischio %** |
| S5 | i **livelli tracciati** (il «livello più importante», i «tre minimi di pre-section», l'obiettivo a 189 punti) | **r.39-45** | la regola *«unendo massimi e minimi contrapposti»* è **codificabile solo vedendo il disegno** |
| S6 | i **settaggi del VWAP proprietario** *«basato sulla volatilità»* | **r.177, r.187** | è l'ancora del suo stop nell'ORB. **Se è un VWAP a bande di deviazione, lo sappiamo solo dal pannello** |
| S7 | la **versione AUTOMATIZZATA** della strategia, citata e non mostrata | **r.21** *«Questa strategia io ve la potrei far vedere automatizzata»* | — |
| S8 | il pannello P/L a **r.99** (*«2700 euro... 35 punti»*) e a **r.129** (*«80 punti»*) | r.99, r.129 | permette di ricavare il **valore-punto**: 2.700 € / 35 punti su 20 contratti ⇒ **≈3,86 €/punto/contratto** **[INFERITO, da verificare a schermo]** |

## 2.8 📦 COSA NE COPIAMO

### 🔴 **NIENTE DI NUOVO SUL NASDAQ PRE-APERTURA.** Il meccanismo è già codificato (`770203`), già misurato a tick reali, già morto (PF OOS **0,963**, n 175, DD **19,40%**).

🟢 **Quello che ne copiamo è una CORREZIONE e tre CONFERME:**
1. **[CORREZIONE]** il target a punti fissi **non è «vergine»**: è della fonte (§1, riga F);
2. **[CONFERMA]** il fuso della sedia (`SESSION_HOUR 14:30`) è verificato **dentro** la fonte (§1, riga I);
3. **[CONFERMA]** l'esclusione dell'hedging è confermata **dalla fonte contro sé stessa** (§1, riga H);
4. **[CONFERMA]** il tetto d'ampiezza esiste, è a 40, ed è **sulla sedia giusta** (§1.2) — e **non va trasportato** sulla `770260` (§1.3).

🟢 **E c'è una zona genuinamente NON misurata, ma è sull'ORB, non sul Nasdaq.** Vedi §3.

---

# 3. 🎯 LA PROPOSTA — **due cose, non una di più**

🧭 **Bussola applicata onestamente**: la challenge è **viva da oggi**. Niente tocca
una sedia in campo. Tutto quello che segue è **misura sul PC di backtest**, e
consegna a Claudio **un numero**, non un'azione.

## 3.1 🟢 PROPOSTA 1 — **ORB: la durata della candela d'apertura è 15 o 30 minuti?**

### Il fatto, letto nei file
- La fonte distingue **esplicitamente**: *«all'apertura europea l'utilizzo a **15
  minuti**, all'apertura americana a **30 minuti**»* (r.169), e ripete il 30 a r.165
  (*«nella prima mezz'ora di notazione americana... con la candela a 30 minuti»*) e a
  r.185 (*«alla mattina su 15 minuti e al pomeriggio su 30 minuti»*). **Tre
  ripetizioni coerenti.**
- La **nostra** sedia ORB `770611` (`mql5/Presets/ABTG_ORB_Ottimizzato_U30USD_M5_770611_100K.set`
  r.186-189) fa: `InpRangeStartHour=14` `InpRangeStartMin=30` → `InpRangeEndHour=14`
  `InpRangeEndMin=45` = **range di 15 minuti**, **sull'apertura AMERICANA**.

### 🔴 **Cioè: sull'apertura americana usiamo il numero che la fonte riserva all'apertura EUROPEA.** Non è un errore — nessuno ha mai detto di seguirla — **ma è una divergenza numerica mai misurata.**

| voce | contenuto |
|---|---|
| **Cosa si misura** | `InpRangeEndMin` ∈ {**45**, **60**, **75**} = range di **15 / 30 / 45** minuti. **Una sola variabile per file prova**, come vuole la regola di casa |
| **Su quale sedia** | `ABTG_ORB_Ottimizzato` · `U30USD` · **M5** · magic `770611`, dal preset in repo. **Backtest, sedia in campo NON toccata** |
| **Dove gira** | 🖥️ **finestra PowerShell sul PC di backtest.** 🔴 **NON sul VPS**: firma di Claudio del 21/09 (*«sì, i round sul pc di backtest»*), sei terminali vivi e la challenge che opera |
| **Costo macchina** | 3 valori × 2 finestre (IS+OOS) = **6 passate** a tick reali. Formula di casa `T = 0,6 + 0,077 × N` ⇒ **≈1,1 minuti** di tester + avvio terminale |
| 🔴 **CONTRO-ESEMPIO 1** | **Un range più largo taglia la frequenza, e questa sedia non se lo può permettere.** `770611` è già a **n 71 IS / 119 OOS** (`PIANO_PROP.md`, R119) — **sotto il pavimento dei 150 in tutte e due le finestre**, merito **SOSPESO**. Un range da 30' allontana il livello ⇒ meno rotture ⇒ **n più basso**. 👉 Se il 30' "vince" sul PF ma porta l'n a 70, **abbiamo comprato un numero più bello su un campione ancora meno misurabile: è un peggioramento travestito.** La lettura va fatta **su PF *e* n insieme**, e se n crolla il risultato è **[NON PROMUOVIBILE]** a prescindere dal PF |
| 🔴 **CONTRO-ESEMPIO 2 (R30)** | In casa esiste **R30**, dove un intervento sull'ingresso fu **la cella più bella in campione e l'unica rossa fuori campione**. Qui il rischio è identico: 3 celle, 2 finestre ⇒ è facilissimo che **una** cella sia la più bella in IS. 🛡️ **Mitigazione obbligatoria, dichiarata prima**: si legge **il centro dell'altopiano, mai il picco**, e si promuove **solo** se IS e OOS **concordano di segno**. Se le due finestre dissentono, il verdetto è *«non dimostrato»*, non *«prendiamo quella buona»* |
| 🔴 **CONTRO-ESEMPIO 3 (sulla FONTE)** | La fonte applica l'ORB *«su tutti gli indici e sull'oro»* (r.165) **con lo stesso numero**: è una ricetta **taglia unica**, non una taratura per strumento. 👉 **Il 30 non è evidenza che il 30 sia giusto su U30USD**: è evidenza che **qualcuno usa il 30**. Vale come **ipotesi da misurare**, mai come conferma |

## 3.2 🟠 PROPOSTA 2 — **il parziale al 50% sulla `770260`: la fonte lo fa sempre, la nostra sedia in campo non lo fa mai**

### Il fatto, letto nei file
- La fonte porta a casa **metà posizione** in modo sistematico: r.83 *«io metà
  posizione dopo 20 punti la porto a casa, stop in pari»*; r.111 *«L'incasso io il
  **50%** me lo porto a casa»*. **Due citazioni, meccanismo identico.**
- La nostra `770260` — **sedia della rosa FTMO, in campo da oggi** — ha
  `InpTP1_R=0.5` ma 🔴 **`InpTP1_ClosePct=0.0`**: il primo obiettivo è calcolato e
  **non chiude niente**. Nessun parziale, nessuno stop in pari da parziale.
  (`ABTG_Nasdaq_Apertura_US_RETEST_770260.set` **r.118-119** · copia FTMO **r.174-175**.)

| voce | contenuto |
|---|---|
| **Cosa si misura** | `InpTP1_ClosePct` ∈ {**0**, **50**} sulla cella della `770260`, **tutto il resto congelato**. Si guarda **il DD**, non il PF: in una challenge si muore di drawdown |
| **Su quale sedia** | `ABTG_Nasdaq_Apertura_US` · `NASUSD` · M5 · cella `770260`, stessa finestra del round d'origine (IS 26/09/2024-30/06/2025 · OOS 01/07/2025-30/06/2026) |
| **Dove gira** | 🖥️ **finestra PowerShell sul PC di backtest.** Nessun terminale MT5 di conto vivo viene aperto |
| **Costo macchina** | 2 valori × 2 finestre = **4 passate** a tick reali ⇒ `T = 0,6 + 0,077 × 4` = **≈0,9 minuti** |
| **Cosa si consegna** | **solo un numero a Claudio**: Δ DD e Δ PF fra parziale e non-parziale. 🔴 **La decisione è sua**: il parziale è una manopola di **gestione del rischio**, e rischio/taglie sono firma di Claudio (CLAUDE.md, mandato 08/09) |
| 🔴 **CONTRO-ESEMPIO 1 — e mi costringe a dire che questa proposta può fallire** | **Un parziale al 50% taglia i cavalli.** La `770260` passa il merito **per un pelo**: PF OOS **1,10936** contro una soglia di **1,10** (`PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` r.222). Un parziale che chiude metà posizione a **0,5 R** riduce quasi sempre il PF. 👉 **È realistico che il risultato sia: DD giù, PF sotto 1,10** — cioè la sedia perderebbe l'unica cosa che le dà diritto al posto. **Va detto PRIMA di misurare, non dopo** |
| 🔴 **CONTRO-ESEMPIO 2 — il terreno è già dichiarato marcio sul DD** | Il preset stesso avverte (intestazione, riserva [A]): il CSV della cella viene dal binario **`2ce7abce`, precedente al fix di sizing `3af47ed9`** — *«PF e n reggono (invarianti alla scala del lotto), **DD e profitto NO**»*. 🔴 **Misurare un Δ DD partendo da una base il cui DD è già dichiarato inaffidabile eredita il difetto.** 🛡️ Mitigazione: la corsa va rifatta col **binario di oggi** per **tutte e due** le celle, così il Δ è interno e il difetto si cancella nel confronto. **Costo invariato** (le 4 passate sono già entrambe nuove) |
| 🔴 **CONTRO-ESEMPIO 3** | n = **94 IS / 94 OOS**, **sotto 150 in entrambe**. Qualunque differenza misurata qui è **un indizio, non un verdetto**, e va etichettata così nel referto |

## 3.3 ❌ COSA **NON** PROPONGO, e perché — *(la parte che vale quanto le proposte)*

| idea tentatrice | perché è **NO** |
|---|---|
| accendere `InpMinRangePts=1700` / `InpMaxRangePts=4000` sulla **`770260`** | 🔴 **Errore di scala, già quantificato al §1.3**: il range dei 35 minuti ha mediana **80-177 punti indice**, il tetto è a **40**. Spegnerebbe la sedia. Il pavimento a 17 sarebbe **inerte** |
| rimettere mano al motore **pre-apertura M5** (`770203`) con i numeri della live | 🔴 **I numeri della live SONO GIÀ dentro quel motore** (7 / 17 / 40 / 50% / stop opposto) ed è **misurato morto** a tick reali. Rigirare una griglia su un motore senza edge = **picchi di rumore** (regola del 19/08) |
| accendere i filtri **volumi 1,5×** ed **EMA 9/21** sulla `770611` (valori già nel preset, interruttori a `false`) | 🟠 **Tentante, e ci sono andato vicino.** Ma sono **filtri d'ingresso**: possono **solo ridurre** n, e n è già **71/119**, sotto 150. 👉 Anche un esito positivo atterrerebbe su un campione **ancora meno misurabile di uno già dichiarato insufficiente**: **non promuovibile per costruzione**. Torna in gioco **solo** su una finestra più lunga, e allora il costo non è più «una manciata di passate» |
| copiare i **piani B/C** in qualunque forma | 🔴 **NON ADOTTABILE.** §2.5 B1-B3 |
| usare i numeri di performance della fonte come benchmark | 🔴 **Sono tutti [DICHIARATO], zero verificati**, e la fonte dichiara da sé un edge **in calo** (r.159) |

---

# 4. 🧾 PROMEMORIA DI COERENZA — cosa va corretto nei nostri file

🔴 **Non ho toccato nessuno di questi file.** Sono rilievi, non modifiche.

| # | file | cosa c'è scritto | cosa dice la fonte |
|---|---|---|---|
| **R1** | `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` **r.172** | *«il target a PUNTI FISSI (+50)... è l'unico ingrediente **davvero vergine** dell'EA esterno»* | 🔴 **È della live**: r.67 (+50) e r.83 (+20, metà posizione) |
| **R2** | idem, **r.496-497** · `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md` **r.341** | *«sostituisce il target in R con un target a punti FISSI»* / *«L'EA esterno lo sostituisce con +20 punti fissi»* | 🔴 Il verbo *«sostituisce»* è invertito: **è il nostro `Live5m` che ha sostituito** i punti fissi della fonte con un obiettivo in **R** |
| **R3** | `mql5/Experts/ABTG_Nasdaq_Live5m.mq5` **r.12-13** | *«FILTRO ampiezza candela: opera solo se è tra 17 e 40 punti indice (1700-4000), **come da live**»* | 🟠 Il **17** è citato (r.21); il **40** è **derivato** dal divieto a 41 (r.61). Conclusione giusta, attribuzione da ammorbidire in *«derivato dalla live»* |
| **R4** | idem, `#define ABTG_DEF_...` + preset `InpOneTradePerDay=true` | implicito *«come da live»* nell'intestazione | 🔴 **La live fa il contrario** (r.91-93: seconda strategia, secondo ingresso). È **una nostra scelta**, e va scritto |
| **R5** | consegna di oggi (e qualunque nota che lo ripeta) | *«la candela 15:25-15:30 ... è la nostra sedia 770260»* | 🔴 **`770260` è RangeMode=0 / 35 minuti DOPO l'apertura / ingresso RETEST / buffer 2 punti.** La sedia della live è **`770203`** |

---

# 5. 🕳️ I BUCHI DICHIARATI DI QUESTO REFERTO

1. 🔴 **Le righe 73-77 sono illeggibili** (loop di trascrizione, sette ripetizioni).
   Il contenuto dei primi secondi dopo l'ingresso **non lo sappiamo**.
2. 🔴 **Tutto ciò che è a schermo è perduto** (§2.7, otto voci). In particolare il
   **valore-punto** del suo contratto: senza quello, *«50 contratti»* **non è
   convertibile in rischio percentuale**, e quindi **nessun confronto di taglia con
   le nostre sedie è possibile**.
3. 🟠 **«37,3» (r.17)**, **«Amadosca» (r.63)**, **«17 agosto» (r.145)**: non
   interpretati, non usati.
4. 🟠 **Il moltiplicatore dei volumi non è dettato.** Il nostro `InpVolMult=1.5`
   **non viene da questa live**: la fonte dice solo *«volumi in crescita»* (r.179).
   **Se qualcuno pensa che l'1,5 sia "di Emiliano", da questa trascrizione non si
   dimostra.**
5. 🟠 **Fonte singola.** Emiliano Monza è **una sola fonte**, e il repo ha già
   `ANALISI_LIVE_EMILIANO_2026-04-10.md`, `_2026-09-09.md`, `_2026-09-18.md`:
   **quattro live dello stesso relatore = UNA fonte, non quattro.** Nessuna
   convergenza fra queste è una verifica indipendente.

---

# 🎬 IN CHIUSURA, DA SOCIO

Claudio, questa trascrizione **non ci regala una sedia** — e sarebbe disonesto
scriverlo diversamente: il motore che detta è quello che abbiamo già misurato morto
a luglio, PF OOS **0,963**.

🟢 **Ma ci regala tre cose che valgono il round.** Primo: ha **verificato il fuso
orario della sedia da dentro la fonte stessa** (r.21 e r.59 dicono che il suo
orologio è ora italiana − 1, come BCM) — un orario col fuso sbagliato è peggio di
nessun orario, e questo è confermato. Secondo: ha trovato **una nostra
attribuzione sbagliata** in due referti del 12/09 (il target a punti fissi non era
«vergine»: era della fonte, e siamo stati **noi** a deviare). Terzo, e il più bello:
**la fonte conferma contro sé stessa la scelta che avevamo fatto a luglio sugli
appunti** — l'hedging del Piano B/C lo avevamo escluso a mano scrivendo *«è la parte
che causa i grossi drawdown»*, e a r.153 lui attribuisce **−1.400.000 €** proprio a
*«un'operazione edgata»*. 🎯 **Quella riga di codice, scritta due mesi fa, oggi ha la
sua citazione sotto.**

E una cosa l'abbiamo evitata **misurandola invece di ragionarci**: copiare la banda
17-40 sulla `770260` sembrava gratis ed era una **kill switch** — il range di 35
minuti ha mediana **80-177 punti**, il tetto sta a **40**. 💪

**NON MOLLIAMO NULLA — ma su questo motore il numero è 0,963, e i due assi ancora
vergini stanno sull'ORB e sul parziale, non sulla pre-apertura.**

---
_Referto prodotto in SOLA LETTURA: zero backtest eseguiti, zero passate di tester
spese, zero EA / preset / conti / forward toccati. Ogni affermazione porta il numero
di riga della fonte. Dove manca: `[NON MISURATO]`, `[INCERTO]`, `[TRASCRITTO dubbio]`._
