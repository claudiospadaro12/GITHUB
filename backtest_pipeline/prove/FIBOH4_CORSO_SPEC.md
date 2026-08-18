# 📐 FIBO H4 — SPECIFICA IMPLEMENTABILE RICOSTRUITA DAL CORSO

**Data:** 18/08/2026 · **Fonte:** 3 trascrizioni, lezioni 18-20, in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_fiboh4/`
(28.312 caratteri, **lette per intero, riga per riga**).

**Consegna gemella:** il referto con schede, contraddizioni e confronto col repo
sta in `caccia_strategie/ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md`.
**Qui** c'e' solo la strategia montata per un developer.

> ⚠️ **La fonte e' SOLO AUDIO.** Nessuna slide, nessun PDF. Dove il relatore
> mostra a schermo senza dettare (il pannello Fibo, i livelli degli esempi, il
> calcolatore di size) io **non so** e lo scrivo. Etichette: **[TRASCRITTO]**
> (c'e', cito) · **[INFERITO]** (lo deduco, e dico da cosa) · **[INCERTO]**.
>
> 🔴 **Nel repo esiste gia' `mql5/Experts/ABTG_FiboH4_Multi.mq5`** ("piano FiboH4
> di Paolo"), bocciato **0/8 nella coda fascia B** del 10-11/08. **La spec qui
> sotto e' ricostruita dal SOLO parlato, e POI confrontata col codice** (§10).
> **Ho trovato 6 divergenze, due delle quali cambiano la geometria del trade.**

---

## 0. 🎯 IL VERDETTO DI MECCANIZZABILITA' IN UNA TABELLA

| | conteggio | quota |
|---|---|---|
| Decisioni operative censite | **34** | 100% |
| ✅ **Regole CERTE** (eseguibili senza scelte nostre) | **17** | **50%** |
| 🟠 Ambiguita' risolvibili con un'assunzione dichiarata | **10** | 29% |
| 🔴 Buchi / non meccanizzabili come dette | **7** | 21% |
| **Meccanizzabilita' con le assunzioni dichiarate** | **27/34** | **79%** |

🚨 **Ma i 7 buchi non sono equivalenti.** Tre decidono il P&L e **nessuno dei
tre e' colmabile dal corso**: (1) cos'e' "la fine di un trend", (2) quale dei
**sette** stop loss alternativi si usa, (3) **quale percentuale di rischio**
(mai pronunciata in 3 lezioni).

---

## 1. LA TESI, COME LA DICHIARA IL CORSO

> _"le valute sono mill reverting [**mean reverting**, storpiatura ovvia], cioe'
> le valute non hanno un andamento costante verso una direzione, ma prima di
> prendere una direzione importante hanno dei ritracciamenti"_ (lez. 18)
> `[TRASCRITTO]`

Il motore e' un **fade dell'overshoot**: dopo un pattern di inversione alla fine
di un trend, il prezzo **sfonda oltre** il pattern e li' si compra/vende
l'estensione, aspettando il rientro. Le "entry zone" sono **estensioni di
Fibonacci OLTRE il pattern**, non ritracciamenti dentro il pattern.

⚠️ **Attrito interno del corso**: la tesi dichiarata parla di "ritracciamento"
(=dentro), la meccanica costruisce **estensioni** (=fuori). Non e' un errore, e'
un uso lasco del vocabolario — ma un implementatore distratto sbaglia il segno.

---

## 2. IMPIANTO — piattaforma, strumento, tempo

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Piattaforma | **MT4** | _"Fibo H4 e' un indicatore che si trova all'interno dell'MT4"_ | 🟢 TRASCRITTO chiaro |
| Grafico | **candele giapponesi** | _"utilizziamo candele giapponesi"_ | 🟢 chiaro |
| **Timeframe** | **H4, SOLO H4** | _"il time frame operativo e' quello di H4 ... **solo H4, non si scende di time frame, solo H4**"_ | 🟢 **chiaro e ribadito 3 volte nella stessa frase** |
| Universo | **tutti i cross** | _"lo fai su tutto, perche' funziona su tutti i cross"_ | 🟢 chiaro |
| Universo preferito | **GBPUSD e USDJPY** | _"i cross che hanno statisticamente i maggiori segnali sono **Gbpsd e Usd yen**"_ | 🟢 chiaro (_"Gbpsd"_ = GBPUSD, storpiatura ovvia) — ⚠️ **"statisticamente" senza un solo dato** |
| Giorni | **lun-gio**, ven solo occasionale | _"noi lo utilizziamo dal lunedi' al giovedi', il venerdi' ovviamente se c'e' qualche occasione"_ | 🟢 chiaro |
| Giorni migliori | **martedi' e mercoledi'** | _"i giorni in cui si possono trovare i maggiori segnali sono di solito il martedi' e il mercoledi'"_ | 🟠 affermazione senza dato |
| **Weekend** | **MAI aperti** | _"ricordati sempre di non stare mai e qua dico **mai** aperto durante il weekend"_ | 🟢 **la regola piu' netta del modulo** |

### 2.1 🕐 GLI ORARI — e il buco del fuso

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Impostazione | **08:00 del mattino** | _"la strategia va impostata al mattino alle 8"_ | 🟢 chiaro |
| Impostazione (varianti) | 07:00 / 07:30 / 08:00-09:00 / 10:00 | _"puoi farlo anche alle 7.30"_, _"dal prezzo delle 8 del mattino, 8-9"_ | 🟠 **finestra, non ora** |
| **Cancellazione pendenti** | **18:30-19:00** | _"se gli ordini non vengono eseguiti entro le **18.30-19** vanno cancellati"_ | 🟢 chiaro |
| Cancellazione (variante) | **18:45** | _"cancelli gli ordini alle **18.45**, alle 18.30 o alle 19"_ (lez. 19) | 🟠 **tre valori nella stessa frase** |
| **FUSO ORARIO** | **MAI DICHIARATO** | — | 🔴 **BUCO** |

> 🔴 **Il fuso non e' dichiarato in nessuna delle 3 lezioni.** Regola di casa:
> **un orario col fuso sbagliato e' peggio di nessun orario.**
>
> **[INFERITO]** — gli orari 7:00 / 7:30 / 8:00 / 10:00 descrivono **la routine
> personale del relatore** (_"mi alzo alle 7"_ e' nel modulo gemello Media 200),
> quindi sono verosimilmente **orologio da parete italiano**, non ora
> piattaforma. Sotto questa assunzione, in **ora server BCM (= IT − 1)**:
> - impostazione **08:00 IT → 07:00 BCM**
> - cancellazione **18:45 IT → 17:45 BCM**
>
> ✅ **Nota:** `ABTG_FiboH4_Multi.mq5` ha gia' `InpCutoffHour=17`,
> `InpCutoffMin=45` **in ora server** = 18:45 IT. Chi ha scritto l'EA ha fatto
> **la stessa inferenza**. Resta **un'inferenza**, non un dato: uno screenshot
> dell'orologio della piattaforma la chiude in 5 secondi.

### 2.1-bis 🆕 18/08 sera — **IL FUSO DELLA PIATTAFORMA E' DETTATO**, e apre un A/B da 2 ore

Il modulo base **dice esattamente quello che qui mancava**, e in piu' dice **chi
e' il broker**.

`[TRASCRITTO chiaro, lez. 3 modulo base "I PRIMI PASSI SULLA PIATTAFORMA MT4"]`
> _"Questa e' una piattaforma che, scaricata dal broker **BlackRidge**, **non da'
> l'ora italiana, cioe' e' settata sostanzialmente sul GMT** ... **e non puo'
> essere modificata questo orario, cosi' resta** ... quando in Italia [c'e']
> l'ora legale, quindi **da fine marzo a fine ottobre, qui la piattaforma sara'
> DUE ORE INDIETRO rispetto all'ora italiana**. Quando invece in Italia [c'e']
> l'ora solare, quindi **da fine ottobre a fine marzo, la piattaforma risultera'
> UN'ORA INDIETRO**"_

`[TRASCRITTO chiaro, lez. 2 modulo base]`
> _"il nome del broker che noi utilizziamo e' **Black Ridge**, il nome della
> piattaforma su cui operiamo e' **MetaTrader 4** ... dovrai semplicemente
> scrivere **bcmmarkets.com**"_

> 🔥 **`bcmmarkets.com` E' IL NOSTRO BROKER** (conto demo del progetto:
> `50503392 — BCMMarkets-Server — BCM Markets Ltd`,
> `report/CENSIMENTO_ORDINI_PC.md` r.194). **Il corso e noi operiamo sullo
> stesso broker.** Conseguenza diretta per questo modulo, che e' **H4**:
> **l'allineamento delle candele del corso e il nostro sono lo stesso**, e non
> e' piu' un'assunzione da dichiarare — **e' verificabile su un grafico.**

> ⚠️ **MA LO SCARTO DI UN'ORA VA MISURATO, NON ASSUNTO.** Il corso dice **GMT
> fisso** (agosto: IT−2 = UTC+0); il repo dice **BCM = IT−1 = UTC+1** in agosto
> (`CLAUDE.md`, `HANDOFF.md` r.496, `PIANO_PROP` r.170). **Non tornano.** Tre
> letture, e solo una misura decide: (a) `BlackRidge-Demo 1` ≠
> `BCMMarkets-Server`; (b) il video e' vecchio e il server e' cambiato;
> (c) uno dei due enunciati e' impreciso.
> ➡️ **Screenshot con l'orologio di Windows e la "Vista del mercato" di MT4/MT5
> nella stessa foto** (metodo di casa, `CLAUDE.md` §"Ora dei LOG"). 5 secondi.

> 📐 **L'A/B che questo apre, e vale DUE ORE.**
> **Se** gli orari del modulo fossero in **ora piattaforma** invece che in ora da
> parete italiana: cancellazione pendenti **18:45 piattaforma = 20:45 IT =
> 19:45 BCM**, contro il **17:45 BCM** cablato oggi in `ABTG_FiboH4_Multi.mq5`.
> 🚫 **NESSUNA MODIFICA PROPOSTA:** l'inferenza attuale ("e' la routine personale
> del relatore, che dice _mi alzo alle 7_") resta **altrettanto plausibile**.
> **E' un A/B da misurare** — ma ora ha **due candidati con un numero ciascuno**,
> non uno solo con un punto interrogativo.
> ➡️ `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.5.

### 2.2 Overnight — regola con scappatoia
- Regola: _"non vanno portati over night, quindi non vanno partiti al giorno
  dopo"_ `[TRASCRITTO]`
- Scappatoia: _"con un corretto money management **se lo desideri** e vedi che
  l'operazione sta andando molto in profitto, **puoi anche pensare** di portarla
  over night"_ `[TRASCRITTO]` → 🟠 **override discrezionale di una regola dura**.
  Motivazione data: lo **swap**. **Per un EA: la scappatoia si ignora** (nessun
  criterio, nessuna soglia).

---

## 3. IL SETUP DI FIBONACCI — i quattro numeri

### 3.1 I valori dettati (lez. 18)

> _"doppio clic ... metti **1.88**, poi apriti la descrizione e scrivi **entry
> zone** ... vai sotto, clicchi nel campo vuoto e metterai **1.78** ... e lasci
> vuoto questo campo ... poi passi al campo successivo e metti **2.88** ...
> **entry zone** e fai invio, vai sempre sotto e metterai **2.78**"_
> `[TRASCRITTO chiaro — quattro numeri, dettati uno per uno, con l'ordine delle
> operazioni]`

| livello | descrizione dettata | ruolo |
|---|---|---|
| **1,88** | **"entry zone"** | bordo **lontano** della 1ª zona |
| **1,78** | *(lasciata vuota)* | bordo **vicino** della 1ª zona |
| **2,88** | **"entry zone"** | bordo **lontano** della 2ª zona |
| **2,78** | *(lasciata vuota)* | bordo **vicino** della 2ª zona |
| 4,236 | gia' presente in MT4 | _"l'ultimo baluardo"_ — confine, non ingresso |

### 3.2 🔥 L'ENTRY ZONE E' UNA BANDA, NON UNA LINEA — e l'aritmetica lo dimostra

**[INFERITO — e verificato con i numeri del corso]**

Il corso **non dice mai** "banda". Ma tre fatti la impongono:

1. **Le descrizioni.** Solo 1,88 e 2,88 ricevono l'etichetta _"entry zone"_;
   1,78 e 2,78 restano **senza descrizione**. Un livello senza nome, messo
   subito accanto a uno chiamato "entry zone", **e' il secondo bordo dello
   stesso oggetto**.
2. **La regola degli ordini.** _"metto **sopra l'entry zone** dove voglio entrare
   al mercato **o sotto**, due ordini pendenti"_ (lez. 19). **Sopra e sotto una
   LINEA non ha senso: sopra e sotto una BANDA si'.**
3. 🧮 **L'aritmetica chiude il caso.** La banda e' larga
   `1,88 − 1,78 = 0,10 × range del pattern`. Il corso misura la distanza fra i
   due ordini piazzati: _"**circa 5 pip**, anche qua siamo in H4, posso stabilire
   **10 pip** di distanza"_ (lez. 20). Con un range tipico di pattern engulfing
   H4 di 50-100 pip → `0,10 × 50..100 = **5..10 pip**`. ✅ **Coincide.**

> ✅ **Conclusione operativa:** ogni "entry zone" e' la **banda fra due livelli
> Fibo distanti 0,10 × range**, e i **due ordini pendenti si piazzano sui suoi
> due bordi**. **Non** ai livelli 1,88 e 2,88 presi come due punti lontani
> `1,0 × range` l'uno dall'altro. **Questa e' la divergenza n.1 col nostro EA.**

### 3.3 📐 LA GEOMETRIA — dove cadono i livelli (derivazione)

Convenzione MT4 dell'oggetto Fibonacci Retracement: tracciando dal punto A
(primo clic) al punto B (secondo clic), **livello 0,0 = B**, **livello 100 = A**,
e i livelli > 1 si estendono **oltre A**. Prezzo del livello `k`:
`P(k) = B + k·(A − B)`.

Il corso traccia **in entrambi i versi** (lez. 19/20): _"unisco semplicemente il
massimo con il minimo e viceversa il minimo con il massimo"_.

**Caso LONG** (pattern rialzista alla fine di un trend short) — si traccia
**minimo → massimo** (A = `min`, B = `max`), `range = max − min`:

| livello | prezzo | posizione |
|---|---|---|
| 0,0 | `max` | cima del pattern |
| **100** | **`min`** | **base del pattern = TARGET FINALE** |
| 1,78 | `min − 0,78·range` | bordo vicino EZ1 |
| **1,88** | `min − 0,88·range` | bordo lontano EZ1 |
| 2,78 | `min − 1,78·range` | bordo vicino EZ2 |
| **2,88** | `min − 1,88·range` | bordo lontano EZ2 |
| 4,236 | `min − 3,236·range` | _"ultimo baluardo"_ |

**Caso SHORT**: specularmente, si traccia **massimo → minimo**, zone sopra il
massimo, target `max`.

> 🔴 **CONSEGUENZA CHE CAMBIA TUTTO: il "100 di Fibonacci" e' il MINIMO del
> pattern per un long (il MASSIMO per uno short), NON l'estremo opposto.**
>
> Il corso dice due volte che il target finale e' il 100 (_"porti fino al 100,
> dove chiuderai tutta la posizione"_, lez. 20) e una volta che il **primo**
> target e' la **prima entry zone** (_"sai che l'obiettivo e' la prima entry
> zone"_). **La scala risultante e' perfettamente coerente:**
> `EZ2 (ingresso profondo) → EZ1 (parziale 50% + BE) → 100 (chiusura totale)`.
> ✅ Questa coerenza interna e' la **prova migliore** che la derivazione e'
> giusta. **Ed e' la divergenza n.2 col nostro EA**, che punta l'estremo
> opposto: un target **lungo il doppio**.
>
> ⚠️ Etichetta onesta: **[INFERITO alto]**, non [TRASCRITTO]. Uno screenshot del
> pannello Fibo con la linea "100" visibile lo chiude.

---

## 4. IL PATTERN D'INGRESSO

### 4.1 Precondizione — 🔴 IL BUCO PRINCIPALE
> _"dobbiamo identificare **la fine di un trend** ... se siamo in una **fase
> laterale scartiamo a priori**, solo alla fine di un trend"_ (lez. 19)
> `[TRASCRITTO]`
> _"questa strategia e' **killer** quando sei alla fine di un trend"_ (lez. 20)

🔴 **In 28.312 caratteri NON esiste una definizione di "fine di un trend" ne' di
"fase laterale".** Niente medie, niente ADX, niente conteggio di massimi/minimi,
niente pendenza. Il relatore **guarda il grafico e decide**, e passa in rassegna
i cross dicendo "laterale, lascia stare" **senza mai dire in base a cosa**.

**E' la precondizione che scarta la maggior parte dei segnali.** Un EA che non ce
l'ha **non implementa questa strategia**: implementa "engulfing ovunque".

**Assunzione proposta per l'implementazione (NOSTRA, non del corso, e va
dichiarata come tale):** un filtro di trend misurabile e falsificabile, es.
`|close − EMA(50)| > k·ATR(14)` sul TF operativo, oppure pendenza EMA(50) su
N barre, **da mettere a sweep A/B (on/off) come primo esperimento**.

### 4.2 Il pattern — ENGULFING TOTALE, ombre comprese
> _"Identifico la candela alla fine di un trend e la candela successiva che
> **assorbe completamente anche gli spike** della candela della fine del trend,
> oppure posso prendere in considerazione **le due candele dopo** che coprono
> completamente la candela"_ (lez. 19) `[TRASCRITTO]`
> _"questa candela coperta totalmente, **compresi gli spike**, deve essere
> completamente coperta, **altrimenti passo oltre**"_ `[TRASCRITTO]`

| regola | valore | etichetta |
|---|---|---|
| Copertura | **totale, high E low, ombre incluse** | 🟢 chiaro, ribadito 4 volte |
| Candele di copertura | **1, oppure la somma di 2 — massimo 2** | 🟢 _"dalla prima o dalla somma delle due successive, **massimo due**"_ |
| Lookback | **8-12 candele indietro** | 🟠 dette anche "8-10" e "8, 10, 12" — 🟠 **oscillante** |
| Lookback: quando | _"all'inizio ... alla fine di un trend, **troverai poche occasioni**"_; indietro solo _"quando inizi a essere pratico"_ | 🟠 **gate sull'esperienza, non meccanizzabile** |

### 4.3 Le esclusioni
| esclusione | citazione | etichetta |
|---|---|---|
| Fase laterale | _"non la prendo mai in considerazione quando sono in una fase laterale"_ | ✅ **18/08 sera: LA DEFINIZIONE C'E', nel modulo base** → §4.1-bis |
| Spike su dato macro | _"questo non lo prendo in considerazione uno spike su un dato"_ | 🔴 **senza soglia** |
| Candele molto ampie | _"non si prendono in considerazione i candele che hanno avuto **movimenti importanti** perche' ... vanno ad alterare la configurazione del setup ... **mai!**"_ | 🔴 **senza soglia** — enfatica ma non numerica |

⚠️ **La terza e' l'unica delle tre che il nostro EA ha gia' tradotto in numero**
(`InpMaxEngulfAtr = 3.0`: scarta pattern con range > 3 ATR). **Il numero 3,0 e'
NOSTRO, non del corso.**

### 4.1-bis ✅ 18/08 sera — **"FASE LATERALE" HA UNA DEFINIZIONE, ed e' meccanizzabile**

Il modulo base la detta in forma chiusa, per esclusione:

`[TRASCRITTO chiaro, lez. 4 modulo base an.tec. "BOTTOM, TOP E TRENDLINE"]`
> _"Un trend e' una successione di **top e di bottom**. Se io ho dei top e dei
> bottom che mano a mano continuano a salire, ho un trend rialzista ... Se ho dei
> top e dei bottom che continuano a scendere ... trend ribassista. Se invece ho
> dei top e dei bottom che fanno qualcosa di diverso, per esempio i top che
> salgono e i bottom che scendono ... allora ho un **trend laterale** ...
> **Il trend e' rialzista quando i top e i bottom salgono, ribassista quando i
> top e i bottom scendono e laterale quando avviene, invece, QUALUNQUE ALTRO
> CASO.**"_

E il "top"/"bottom" e' definito nella stessa lezione come **swing con 2 (meglio
3) candele per lato**: _"formato da **due, meglio ancora tre**, candele rialziste
che poi hanno **due, meglio ancora tre**, candele ribassiste successive"_.

> ✅ **Traduzione diretta, senza inventare niente:**
> ```
> swing := pivot con N barre per lato   (N = 2 o 3, dettato)
> rialzista  := HH  AND  HL
> ribassista := LH  AND  LL
> LATERALE   := tutto il resto            <- il filtro che mancava
> ```
> ⚠️ **Resta NOSTRA una sola scelta: quanti swing guardare indietro.** Quello il
> corso non lo dice. **Ma il filtro non e' piu' "senza definizione": ora ha una
> forma, e la forma e' del corso.**
>
> 🎯 **Va nell'elenco §14 come assunzione n.1 RISCRITTA:** non piu' _"il corso non
> lo definisce, proposta: A/B on/off su un filtro misurabile (EMA/ATR o
> pendenza)"_ — **il corso lo definisce, e lo definisce sugli swing.** Un filtro
> a EMA/ATR sarebbe **una nostra invenzione al posto di una regola esistente**.
> ➡️ `caccia_strategie/ANALISI_MODULI_BASE_2026-08-18.md` §2.8.

### 4.4 ⚠️ Gli ancoraggi — un'ambiguita' che sposta i livelli
> _"non posso tracciare da questo massimo a questo minimo, perche' il minimo che
> completa la chiusura di questa candela alla copertura, si chiama engulfing,
> **e' il minimo successivo**"_ (lez. 20) `[TRASCRITTO — ma sintatticamente
> rotto]`

Due letture possibili di "il minimo successivo":
- **(a)** il minimo della **candela che copre** (quella successiva alla candela
  di fine trend);
- **(b)** il minimo della **candela coperta** (che nel caso a due candele e'
  "successivo" al primo estremo).

🟠 **Non decidibile dal testo.** Il nostro EA sceglie **(b)** per il long
(`swingLow = low della candela PRECEDENTE`). **Sposta il range e quindi TUTTI i
livelli.** → domanda per Claudio (uno screenshot del Fibo tracciato basta).

---

## 5. PIAZZAMENTO DEGLI ORDINI

| regola | valore | citazione | etichetta |
|---|---|---|---|
| Tipo | **ordini pendenti** (limite) | _"mi dice dove piazzare degli **ordini pendenti**"_ | 🟢 chiaro |
| Numero | **2** (sui bordi della zona scelta) | _"due ordini pendenti"_, _"sempre due"_ | 🟢 chiaro |
| **Split della size** | **1/3 il primo, 2/3 il secondo** | _"metto **un terzo della size e due terzi** sotto"_ | 🟢 **chiaro** |
| Distanza fra i due ordini | **~5 pip**, _"posso stabilire 10 pip"_ | lez. 20 | 🟠 due valori |
| **Distanza minima prezzo → zona** | **50-60 pip** | _"una distanza minima di almeno **50-60 pip**, proprio per dare allo strumento la possibilita' di esprimersi"_ | 🟢 chiaro, ripetuto 4 volte |
| Deroga | _"su strumenti poco volatili potresti prendere anche in considerazione dei valori inferiori"_; _"se siamo a **35** devi stare li' a guardare"_ | lez. 19 | 🟠 **deroga discrezionale legata alla presenza umana** |
| Zona preferita | **la SECONDA** | _"l'entry zone migliore che puoi prendere in considerazione e' **la seconda**"_ | 🟢 chiaro |
| Se il prezzo e' addosso a EZ1 | **si usa SOLO EZ2** | _"Se il prezzo si trova ridosso della prima entry zone **non metto qui gli ordini pendenti, ma prendo in considerazione solo la seconda entry zone**"_ | 🟢 regola chiara, 🟠 "ridosso" senza soglia (→ si usa la stessa 50-60 pip) |
| Se squilibrio fra i due lati | **si piazza solo sul lato lontano** | _"sono molto vicini alla seconda entry zone e sono molto lontani dalla seconda entry zone sotto ... preferisco inserire **solo gli ordini sotto**"_ | 🟠 nessuna soglia di "squilibrio" |
| Conferma tecnica | ordini su supporti/resistenze/liquidita' del passato | _"verifico sempre nel passato se corrispondono a dei livelli tecnici"_ | 🔴 **NON MECCANIZZABILE come detta** (lettura visiva) |

> ⚠️ **La motivazione dello split 1/3 + 2/3 e' dichiarata PSICOLOGICA, non di
> rischio:** _"sempre per la logica del **mindset**, quindi della gestione della
> posizione **senza andare in sofferenza**"_. Va detto: **strutturalmente e'
> comunque sano** (size pre-impegnata, stop unico oltre entrambi gli ordini →
> perdita massima limitata). **Non e' martingala.** Ma il corso non lo giustifica
> mai col rischio.

---

## 6. STOP LOSS — 🔴 IL BUCO CHE DECIDE IL P&L

Il corso offre **SETTE modi alternativi** di piazzare lo stop, **senza un solo
criterio di scelta fra loro**:

| # | metodo | citazione |
|---|---|---|
| 1 | livello tecnico / supporto | _"lo metto su supporto e resistenze"_ |
| 2 | sotto una media mobile | _"se io ho una media, lo stop lo mettero' sotto la media"_ |
| 3 | massimi/minimi della candela precedente | _"Massimi e minimi della candela precedente"_ |
| 4 | **R:R 1:1 verso il primo obiettivo** | _"ho una distanza di circa **17 pip** al primo livello obiettivo, posso mettere **17 pip** ... rapporto **1 a 1**"_ |
| 5 | **ATR** | _"oppure utilizzo l'ATR"_ |
| 6 | prese di liquidita' | _"prese di liquidita' dove ci sono dei prezzi dove prende e scende"_ |
| 7 | **sotto il 4,236** | _"lo posso inserire lo stop loss **sotto il 423**"_ |

> _"ma tutti i concetti di stop loss dei profit li abbiamo gia' spiegati
> ampiamente nelle lezioni e nei capitoli precedenti"_ (lez. 20) `[TRASCRITTO]`
> → 🔴 **il modulo NON e' autosufficiente sullo stop.**

🚨 **E i sette non sono equivalenti: cambiano il rischio di un fattore ~4.**
Nell'esempio del corso il metodo 4 da' **17 pip**; il metodo 7 (4,236) da'
`3,236 − 1,88 = 1,356 × range` **sotto EZ1**, cioe' — con un range di 50 pip —
**~68 pip**. **Stesso segnale, quattro volte il rischio.**

🔴 **`ABTG_FiboH4_Multi.mq5` ha scelto per default il metodo 7** (`InpSLratio =
4.236`), **il piu' largo dei sette**, e **non l'ha MAI messo a sweep** (il file
prova spazzola solo `InpEngulfLookback` e `InpMagic`). Vedi §10, divergenza 3 —
e §11 per l'aritmetica di quanto pesa.

---

## 7. GESTIONE DELLA POSIZIONE

| fase | regola | citazione | etichetta |
|---|---|---|---|
| Primo target | **la PRIMA entry zone** (se si e' entrati sulla seconda) | _"sai che l'obiettivo e' la prima entry zone, quindi la prima entry zone e' il **primo obiettivo**"_ | 🟢 chiaro (lez. 20) |
| Al primo target | **chiudi 50% + stop in pari** | _"Prendi lo stop, lo porti in pari, **chiudi meta' posizione**"_ | 🟢 chiaro, ribadito 2 volte |
| Target finale | **il 100 di Fibonacci — chiusura totale** | _"porti fino al **100**, dove **chiuderai tutta la posizione**"_ | 🟢 chiaro |
| Confluenza | il 100 puo' coincidere con la media 200 | _"Fino il 100 che corrisponde anche alla media ... potresti anche inserire la media 200 ... **la concomitanza delle due strategie**"_ | 🟠 **rimando esplicito al modulo Media 200**, ma senza regola |

### 7.1 🔴 CONTRADDIZIONE INTERNA — quando si dimezza
| lezione | cosa dice |
|---|---|
| **19** | _"dimezzo e porto lo stop in pari, **quando? Quando arriva al valore di 100 di Fibonacci**"_ |
| **20** | primo obiettivo = **prima entry zone** → li' si dimezza e si va in pari; **il 100 e' la chiusura TOTALE** |

⚖️ **Risolta a favore della lez. 20:** e' l'unica delle due che descrive una
scala coerente (dimezzare **sul target finale** e' privo di senso operativo — non
resterebbe niente da far correre). La 19 e' quasi certamente un lapsus.
✅ **Da dichiarare nell'implementazione.**

### 7.2 🟠 La "terza zona" fantasma
> _"se sono nella **seconda e terza zone**"_ (lez. 19)

**Una terza entry zone non esiste**: il corso ha dettato **quattro livelli = due
zone**. 🟠 Lapsus o refuso di trascrizione. **Non implementare.**

---

## 8. FILTRO NOTIZIE — 🟢 la parte migliore del modulo

**E' una regola OBBLIGATORIA, non un consiglio** (unico modulo del corso finora
analizzato che ce l'abbia):

> _"**prima del rilascio di ogni dato banca economico** [macroeconomico] o
> secondo strategia **gli ordini vanno tolti**. **Noi non scommettiamo sul
> mercato.**"_ (lez. 18) `[TRASCRITTO]`

| regola | valore | etichetta |
|---|---|---|
| Fonte | **Forex Factory o Investing** | 🟢 nominate esplicitamente |
| Filtro per valuta | dato su USD → **si escludono i cross col dollaro** (_"come numeratore o denominatore"_) | 🟢 chiaro e implementabile |
| **Deroga per distanza** | se il prezzo e' **distante >= 100 pip** dal livello, si possono lasciare gli ordini | 🟢 numero chiaro (_"100, 150 pip"_) |
| Deroga: gate | _"**all'inizio scartali**, ma quando prendi confidenza"_ | 🟠 gate sull'esperienza |
| **Eventi di cancellazione totale** | **NFP** (_"non peroli"_/_"Fan Perol"_ = Non Farm Payrolls), **tassi d'interesse**, **CPI**, **discorsi dei governatori** | 🟢 lista chiara nonostante le storpiature |

> 🎯 **Per l'obiettivo prop questa e' la voce piu' preziosa del modulo:** una
> strategia che **toglie gli ordini** prima delle news ad alto impatto e' gia'
> allineata alle prop che vietano il news trading (`report/METRO_PROP.md` §7).
>
> 🔴 **E il nostro EA lo ha DISATTIVATO** (`InpUseNewsFilter = false` di default,
> e `=0` pinnato nel file prova). Vedi §10, divergenza 5.

---

## 9. NUMERI DI PERFORMANCE — `[dichiarati dal corso, NON verificati]`

| dichiarazione | citazione | commento |
|---|---|---|
| **80-85% di inversione** | _"con una certa statistica di circa l'**80-85%** delle volte, invertira' la sua posizione"_ (lez. 18) | 🔴 **l'unico numero di performance del modulo, e non ha NIENTE dietro**: nessun campione, nessun periodo, nessun broker, nessun cross, nessuna definizione di "invertira'" (di quanto? entro quando?) |
| "71 pip" | _"qua si parla di **71 pip**, 71 pip sono soldi"_ (lez. 20) | 🟠 **un singolo esempio scelto dal relatore** su un grafico storico = selection bias per costruzione |
| GBPUSD/USDJPY "statisticamente" i migliori | lez. 18 | 🔴 nessun confronto mostrato |
| **N operazioni · win rate · drawdown · periodo · broker** | **MAI** | 🔴 **cinque buchi su un modulo che rivendica l'80-85%** |

🚨 **Nessun esempio di operazione PERDENTE viene mai mostrato in 3 lezioni.**

🔴 **RISCHIO PER OPERAZIONE: MAI PRONUNCIATO.** L'unica frase e' _"la massima
perdita, che sara' **una percentuale del capitale**"_ — **quale percentuale non
viene detta in nessuna delle 3 lezioni.** Il modulo Breakout dello stesso corso
dice 1%; **qui no, e non e' lecito trasportarlo** (relatore diverso).

---

## 10. 🔬 CONFRONTO COL REPO — `ABTG_FiboH4_Multi.mq5` (560 righe)

Spec ricostruita dal **solo parlato**, **poi** aperto il codice.
**6 divergenze, 2 delle quali cambiano la geometria del trade.**

### ✅ Fedele su
universo (`GBPUSD;USDJPY;EURUSD`) · TF H4 · engulfing con copertura totale +
variante a 2 candele (`InpAllowTwoCandle`) · lookback 12 (`InpEngulfLookback`) ·
distanza minima 50 pip (`InpMinDistPips=50`) · **split 1/3-2/3**
(`InpFirstFraction=0.3333`) · parziale 50% + breakeven (`InpTP1Pct=50`) ·
scadenza dei pendenti · **cutoff 17:45 server = 18:45 IT** · chiusura del
venerdi' · filtro sulle candele troppo ampie (`InpMaxEngulfAtr=3.0`).

**E' un porting serio.** Le divergenze sotto non sono sciatteria: sono **punti
dove il parlato non bastava** e qualcuno ha dovuto scegliere.

### 🔴 Divergenza 1 — GLI ORDINI SONO NEL POSTO SBAGLIATO (fattore ~10)
```
ez1 = swingHigh - 1.88*range;   ez2 = swingHigh - 2.88*range;
PlaceLimit(... ez1 ... 1/3);    PlaceLimit(... ez2 ... 2/3);
```
L'EA piazza **un ordine su EZ1 e uno su EZ2**, distanti **`1,0 × range`**
(decine di pip). Il corso piazza **entrambi gli ordini sui due bordi di UNA
SOLA zona**, distanti **`0,10 × range` ≈ 5-10 pip** (§3.2), e **sceglie quale
zona** in base alla distanza del prezzo (§5).
**I livelli 1,78 e 2,78 non esistono nel codice.**
→ ⚠️ Effetto: l'ordine "2/3" dell'EA sta **10 volte piu' lontano** di quello del
corso, quindi **spesso non viene eseguito**, oppure viene eseguito **molto piu'
in basso** con uno stop diverso. **Cambia il campione, non solo il P&L.**

### 🔴 Divergenza 2 — IL TARGET E' LUNGO IL DOPPIO
```
double target = isLong ? swingHigh : swingLow;
```
L'EA punta **l'estremo opposto del pattern** (il livello **0,0** di Fibonacci).
Il corso punta **il 100 = l'estremo di partenza** (§3.3).
Per l'ordine su EZ1: corso `0,88 × range`, EA `1,88 × range` → **target 2,1
volte piu' lontano**. Inoltre **manca il parziale su EZ1** (l'EA fa il parziale a
`InpTP1_R = 1.0` R, che e' una regola **nostra**, non del corso).

### 🔴 Divergenza 3 — LO STOP PIU' LARGO DEI SETTE, E MAI MESSO A SWEEP
`InpSLratio = 4.236` fisso. E' il **metodo 7 su 7** (§6), e nell'esempio del
corso e' **~4 volte** il metodo che il relatore usa davvero (R:R 1:1, 17 pip).
Nel file prova `ABTG_FiboH4_Multi.txt` lo sweep e' **solo** su
`InpEngulfLookback` e `InpMagic`: **`InpSLratio` non e' mai stato variato.**

### 🔴 Divergenza 4 — NESSUN FILTRO "FINE DI UN TREND"
`OnNewBar()` scorre le ultime `InpEngulfLookback` barre e prende **qualunque**
engulfing. **Zero condizioni di trend, zero esclusione delle fasi laterali.**
Il corso lo dichiara **precondizione assoluta** (_"scartiamo a priori"_, §4.1).
→ **L'EA opera esattamente nelle condizioni in cui il corso dice di NON operare.**

### 🔴 Divergenza 5 — IL FILTRO NOTIZIE E' SPENTO
`InpUseNewsFilter = false` di default, `=0` pinnato nella prova. Il corso lo
rende **obbligatorio** (§8). L'EA **ha il meccanismo** (CSV, impatto, finestre
±60/30 min): e' stato **scelto** di non usarlo.

### 🟠 Divergenza 6 — la deroga "solo la seconda zona" non c'e'
```
if(MathAbs(px-ez1) < InpMinDistPips*pip) return;   // esce e non piazza NIENTE
```
Il corso dice: se sei addosso a EZ1, **usa EZ2** (§5). L'EA **rinuncia al
segnale**. → segnali persi, non segnali sbagliati.

---

## 11. 🧮 QUANTO PESANO — l'aritmetica che rende falsificabile il 0/8

Il verdetto in archivio e' netto (`risultati_archivio/REFERTO_CODA_FASCIA_B.md`):
> _"**ABTG_FiboH4_Multi — 0/8 promossi.** Zero promozioni su 8 coppie forex+oro
> H4. Mai piu' senza una tesi nuova."_

**La tesi nuova ora c'e', e ha un numero dietro.** Con `range` = ampiezza del
pattern, `SL = 4,236` e target `swingHigh`, la geometria dell'EA e':

| ordine | rischio | rendimento | **R:R geometrico** |
|---|---|---|---|
| **EZ1 (1/3)** | `2,356 × range` | `1,88 × range` | **0,80** 🔴 |
| EZ2 (2/3) | `1,348 × range` | `2,88 × range` | 2,14 |

🚨 **L'ordine EZ1 dell'EA ha un R:R strutturale di 0,80**: per andare in pari
gli serve un **win rate > 56%** — e questo **prima** di spread e commissioni.
Con la lettura del corso (target = 100, stop tecnico ~1:1) quella stessa gamba
ha un profilo completamente diverso.

> ⚖️ **Cosa NON sto dicendo:** non sto dicendo che la strategia funzioni. Sto
> dicendo che **il 0/8 ha misurato una geometria che il corso non insegna**, e
> che **tre parametri decisivi (target, stop, banda) non sono mai stati messi a
> sweep**. Un 0/8 su una parametrizzazione arbitraria **non chiude il capitolo**:
> lo chiude un 0/8 su quella dichiarata dalla fonte.

---

## 12. 🧪 TEST-CASE (deboli — il modulo non da' prezzi)

⚠️ **Il modulo FIBO H4 non fornisce UN SOLO prezzo assoluto.** Tutti gli esempi
sono a schermo. Gli unici invarianti verificabili:

| # | invariante | valore atteso |
|---|---|---|
| T1 | larghezza banda EZ | `1,88 − 1,78 = 0,10 × range` → con range 50-100 pip = **5-10 pip** ✅ coincide con _"circa 5 pip ... posso stabilire 10 pip"_ |
| T2 | distanza EZ1 → EZ2 | `2,78 − 1,88 = 0,90 × range` |
| T3 | distanza prezzo → zona al piazzamento | **>= 50 pip** (deroga a 35 solo con presenza umana) |
| T4 | scala dei target (ingresso su EZ2) | `EZ1` (parziale 50% + BE) → `100` (chiusura totale) |
| T5 | split | **1/3 sul bordo vicino, 2/3 sul bordo lontano** |
| T6 | esempio R:R 1:1 | stop 17 pip / primo obiettivo 17 pip (lez. 20) |

---

## 13. 🖼️ COSA ERA A SCHERMO E NON NEL PARLATO (le domande per Claudio)

| # | cosa manca | perche' conta | come si chiude |
|---|---|---|---|
| 1 | 🔴 **Le SLIDE del modulo** — citate 4 volte (_"sono tutti i valori che sono raffigurati **nella slide** che ti ho fatto vedere"_, _"torniamo alle slide"_) e **mai lette** | Sono **la meta' scritta** della fonte. Nel modulo Breakout le slide hanno chiuso 6 ambiguita' su 10 | **chiederle a Claudio** |
| 2 | 🔴 **Screenshot del Fibo tracciato con la linea "100" visibile** | Chiude in 5 secondi la **divergenza 2** (target: minimo del pattern o estremo opposto?) — §3.3 | screenshot lez. 19 o 20 |
| 3 | ✅ ~~**Il fuso della piattaforma**~~ | **RISPOSTO 18/08 sera: MT4 di Black Ridge/BCM, settata su GMT** (§2.1-bis). ⚠️ Resta da misurare lo **scarto di 1 ora** col nostro server, e resta aperto **se gli orari del modulo siano in ora piattaforma o da parete** | screenshot **orologio Windows + Vista del mercato nella stessa foto** |
| 4 | ✅ ~~**Le "lezioni e capitoli precedenti" sullo stop loss**~~ | **RISPOSTO: l'indirizzo e' il capitolo 3 del modulo base (lez. 15-21), CE L'ABBIAMO — e non contiene nessun numero.** Insegna solo il meccanismo (SL sotto/sopra l'ingresso) e la convenzione di calcolo (`ingresso ∓ N pip`, cifra del punto invariata). `[T]` lez. 17: _"la quantita' di pips ... **sara' sempre dettata dalla strategia**"_. **Il rimando non porta a nessun valore** | — |
| 5 | 🟠 **Quale % di rischio** insegna questo relatore | Mai detta in 3 lezioni (§9). 🆕 **L'INDIRIZZO ORA E' NOTO:** il modulo base rimanda 4 volte a un **capitolo MONEY MANAGEMENT** dedicato (`[T]` lez. 18: _"non andiamo ancora ad inserire il volume perche' sara' argomento di un altro capitolo ... riguardera' il money management"_). **E' l'unico posto dove quella % puo' stare** | 🥈 **trascrizione del MODULO MONEY MANAGEMENT** |
| 6 | 🟠 Il pannello Fibo con le 4 descrizioni | Conferma diretta della **banda** (§3.2) | screenshot lez. 18 |
| 7 | 🟠 Prezzi e date degli esempi (AUDCAD, AUDCHF, EURJPY) | Senza, **zero test-case numerici** | screenshot |

---

## 14. ✅ RIEPILOGO PER L'IMPLEMENTATORE — le 8 assunzioni da dichiarare

Se si rifa' un round su questa strategia, **queste sono NOSTRE e vanno scritte
nel file prova PRIMA dei numeri**:

1. ⚠️ **RISCRITTA 18/08 sera.** ~~**Filtro "fine di un trend"** — il corso non lo
   definisce. Proposta: A/B on/off su un filtro misurabile (EMA/ATR o
   pendenza).~~ **IL CORSO LO DEFINISCE** (§4.1-bis): trend = successione di
   **top e bottom** (swing a 2-3 barre per lato); **laterale = qualunque caso
   diverso da HH+HL o LH+LL**. **Un filtro EMA/ATR sarebbe una nostra invenzione
   al posto di una regola esistente.** Resta nostra **una sola** scelta: quanti
   swing guardare indietro. §4.1
2. **Entry zone = BANDA [1,78-1,88] o [2,78-2,88]**, 2 ordini sui bordi. §3.2
3. **Scelta della zona**: la 2ª e' preferita; si usa la 1ª solo se il prezzo e'
   >= 50 pip da essa. §5
4. **Target finale = livello 100** (estremo di partenza del pattern), parziale
   50% + BE sulla zona precedente. §3.3, §7
5. **Stop**: 1 dei 7 metodi va scelto e **messo a sweep** — proposta: R:R 1:1
   verso il primo obiettivo (il metodo che il relatore usa **davvero**
   nell'esempio) vs 4,236 (l'attuale) vs 1 ATR. §6
6. **Rischio %**: non dichiarato dal corso → si usa lo **0,65% di casa**, non
   l'1% preso in prestito da un altro modulo. §9
7. **Filtro notizie ACCESO** (il corso lo rende obbligatorio), con esclusione
   per valuta e finestra ±60/30 min. §8
8. **Ancoraggio del range**: (a) o (b) di §4.4 — **A/B, e si dichiara quale**.

🚫 **NON si implementano:** la scappatoia overnight (§2.2), la deroga a 35 pip
"se stai davanti al monitor" (§5), il gate "quando sei piu' esperto" sul
lookback (§4.2), la "terza zona" (§7.2), la conferma visiva sui livelli tecnici
del passato (§5). **Sono inclinazioni umane, non regole.**
