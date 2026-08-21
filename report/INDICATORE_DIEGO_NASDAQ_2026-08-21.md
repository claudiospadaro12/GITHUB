# 🔎 `DIEGO_Nasdaq_Bands_Indicator` — prima lettura dal pannello input

_21/08/2026, 22:53. Fonte: **screenshot del pannello "Dati in Ingresso"** mandato
da Claudio. **Il sorgente NON e' ancora agli atti** (`find` sul repo: nessun
file `*DIEGO*`). Tutto quello che segue e' letto dai NOMI e dai VALORI degli
input: e' un'ipotesi forte, non una lettura di codice._

Nasce dalla decisione del 21/08 (`FIRMA_2026-08-21_DUE_SEDIE.md`): strada **(b)**
sul Nasdaq, cioe' un round per scrivere un contratto. Claudio ha fermato il
round dicendo *"ASPETTA CHE SUL NASDAQ HO UN INDICATORE CHE POTRESTI
ANALIZZARE"*. Giusto: i criteri si scrivono prima dei numeri, e conviene
scriverli sapendo cosa c'e' in mano.

---

## 1. 📋 I PARAMETRI, COME SI LEGGONO A SCHERMO

| variabile | valore |
|---|---|
| prima di SwitchDate usa blocco ESTATE, dopo INVERNO | `true` |
| data cambio (es. inizio ora solare) | **`2025.11.03 00:00:00`** |
| **ora server della candela 15:25 IT (estate)** | **`15`** |
| `ServerMin_Summer` | `25` |
| **ora server della candela 15:25 IT (inverno)** | **`16`** |
| `ServerMin_Winter` | `25` |
| 1 punto indice = X di prezzo (NQ=1.0) | `1.0` |
| **range minimo ref (pt)** | **`17.0`** |
| **offset ingresso (pt)** | **`24.0`** |
| **offset TP/SL dai livelli di ingresso (pt)** | **`33.0`** |
| ColRefHL / ColEntry / ColTP / ColSL | Silver / Navy / Lime / Tomato |
| `AutoRemovePrevDay` | `true` |
| `ShowLabels` | `true` |

---

## 2. 🎯 CHE COSA E': **un ORB sulla stessa identica candela del nostro**

Il disegno si legge dai nomi, e non lascia molti dubbi:

1. prende **UNA candela di riferimento** (`RefHL`) — quella delle **15:25 IT**,
   cioe' **i 5 minuti prima dell'apertura cash USA** (15:30 IT);
2. la scarta se il suo range e' **sotto 17 punti** (`range minimo ref`) —
   giornata compressa, niente setup;
3. traccia i **livelli d'ingresso** a **24 punti** oltre max e min
   (`ColEntry`, Navy) — quindi **due lati, sopra e sotto**;
4. traccia **TP e SL** a **33 punti** dai livelli d'ingresso
   (`ColTP` Lime, `ColSL` Tomato);
5. cancella i disegni del giorno prima (`AutoRemovePrevDay`).

> ### ⚠️ E' LA STESSA FAMIGLIA DI `ABTG_ORB_Ottimizzato` — stessa candela, stesso meccanismo
>
> `ABTG_ORB_Ottimizzato.mq5` righe 66-69: `InpRangeStartHour=14`,
> `InpRangeStartMin=25`, `InpRangeEndHour=14`, `InpRangeEndMin=30`, col
> commento *"BCM: 14:25 = 15:25 IT"*. **La candela di riferimento e' la
> stessa.** E l'ingresso e' lo stesso schema: pendenti OCO oltre i due estremi.
>
> Questo **non lo squalifica** — ma cambia la domanda del round: non e'
> *"proviamo un motore nuovo"*, e' **"in che cosa questo e' DIVERSO dal
> nostro ORB, che abbiamo gia' misurato a fondo?"**

### 2.1 Le differenze che si vedono gia' dai numeri

| voce | `ABTG_ORB_Ottimizzato` (cella live) | `DIEGO_Nasdaq_Bands` |
|---|---|---|
| candela di riferimento | 15:25-15:30 IT | **15:25 IT** (stessa) |
| distanza d'ingresso | `InpEntryPoints 10` x `K 1.0` = **10 punti indice** | **24 punti** |
| stop | estremo opposto del range (`ORB_SL_OPPRANGE`) — **variabile** | **33 punti fissi** |
| take profit | `InpTP_R = 2.0` → **2R** | **33 punti** → apparente **1:1** |
| filtro ampiezza | `InpMinRangePct` in **% del prezzo** (default 0 = spento) | **17 punti assoluti** |
| simbolo | U30USD (Dow) | **NASUSD (Nasdaq)** |

📌 **La differenza piu' interessante e' il rapporto rischio/rendimento.** Il
nostro ORB punta a **2R**; questo sembra puntare a **1:1** (TP e SL alla stessa
distanza, 33). E' una filosofia opposta: **tanti colpi piccoli** contro
**pochi colpi lunghi**. R55 ha misurato che il nostro ORB *"non muore di PF,
muore di drawdown, e la causa e' lo stop strettissimo"* — uno stop **fisso a
33 punti**, invece che sull'estremo opposto, e' proprio una risposta a quel
difetto. **Vale la pena guardarlo.**

⚠️ **[INFERITO, NON LETTO NEL CODICE]** che TP e SL siano simmetrici: l'input
dice *"offset TP/SL **dai livelli di ingresso**"*, un solo numero per due
cose. Potrebbe anche voler dire "SL sul livello d'ingresso opposto ±33". **Non
si decide a mente: si legge nel sorgente.**

---

## 3. 🔴 IL PROBLEMA CHE SALTA FUORI SUBITO: **L'ORA NON E' QUELLA DI BCM**

Il pannello dice, testualmente: *"ora server della candela 15:25 IT (estate)"*
→ **15**, e *"(inverno)"* → **16**.

Quindi l'autore ha tarato l'indicatore su un broker dove:
- **estate**: 15:25 IT = **15:25 server** (server = ora italiana)
- **inverno**: 15:25 IT = **16:25 server** (server = IT **+1**)

Cioe' un broker fisso a **GMT+2 senza ora legale** — la configurazione piu'
comune fra i broker MT5.

**Ma la regola di casa, misurata e scritta in `CLAUDE.md`, dice l'opposto:**

> *"Il server BCM e' **1 ORA INDIETRO** rispetto all'ora italiana. Ora italiana
> − 1 = ora server BCM. Nasdaq apre 15:30 IT = **14:30 server BCM**."*

E lo conferma il nostro stesso ORB, che per la stessa candela usa **14:25**.

### 🚨 Conseguenza, se il valore fosse ancora quello di fabbrica

| | ora server impostata | che candela pesca su BCM |
|---|---|---|
| **come sta ora (estate=15)** | 15:25 server | **16:25 IT** — cioe' **un'ora DOPO** l'apertura USA |
| **come dovrebbe essere su BCM** | **14:25** server | 15:25 IT — i 5 minuti prima dell'apertura ✅ |

**Starebbe disegnando la candela sbagliata di un'ora esatta**, cioe' su un
momento del tutto diverso: non "i 5 minuti prima della campana", ma "un'ora
dopo l'apertura".

⚠️ **Questo NON e' ancora un verdetto**: (a) e' possibile che Claudio l'abbia
gia' corretto e che lo screenshot mostri il default di fabbrica; (b) lo
screenshot mostra l'indicatore attaccato a **GBPUSD H1**, non al Nasdaq —
probabilmente aperto solo per farmi vedere i parametri. **Si verifica in dieci
secondi guardando il grafico**: vedi §5.

📌 E il valore **INVERNO va MISURATO, non dedotto**: `CLAUDE.md` dichiara lo
scarto di −1 ora *"in questo periodo dell'anno"*. Cosa faccia BCM dopo il
cambio d'ora **non e' agli atti**. Anche `data cambio = 2025.11.03` e' del
**2025**: per il 2026 andrebbe aggiornata comunque.

---

## 4. 🧩 COSA QUESTO SIGNIFICA PER IL ROUND DEL NASDAQ

La strada (b) firmata resta. Ma la domanda del round si affina:

> ### **"Il Nasdaq in apertura ha un edge con lo schema a stop FISSO e target 1:1 — cioe' quello che il nostro ORB a 2R e stop sull'estremo opposto NON aveva?"**

E arriva con un vantaggio raro: **il confronto e' gia' pagato**. Non partiamo
da zero, partiamo da un motore misurato (R15, R55, R88) di cui conosciamo il
difetto nominato — lo stop stretto che gonfia il lotto e fa il drawdown.

⚠️ **Il pericolo, dichiarato subito**: questo indicatore ha **quattro numeri
tarati** (17 / 24 / 33 / le ore) e **nessun referto che dica da dove vengono**.
Prenderli per buoni sarebbe **il difetto del "filtro appiccicato"** al
contrario. Nei criteri andranno etichettati **[DICHIARATI DALL'AUTORE, NON
MISURATI DA NOI]**, esattamente come si e' fatto coi numeri del corso.

---

## 5. ✅ COSA SERVE PRIMA DI SCRIVERE I CRITERI

1. **Il sorgente `.mq5`.** Senza, tre cose restano ipotesi: se TP e SL sono
   davvero simmetrici, se lo stop e' fisso o sull'estremo opposto, e se c'e'
   qualche filtro che dal pannello non si vede. Se esiste **solo il `.ex5`**,
   e' un altro discorso: si misura il comportamento invece di leggerlo.
2. **La verifica dell'ora, sul grafico** — dieci secondi, e non serve nessuno
   script: attaccare l'indicatore a **NASUSD M5**, guardare **quale candela**
   si colora d'argento (`ColRefHL`, Silver), e leggere **l'ora sotto quella
   candela**. Deve essere **14:25 server**. Se e' 15:25, il parametro va
   messo a 14 e tutto quello che ha disegnato finora era spostato di un'ora.
3. ~~**Da dove viene**~~ — **RISPOSTA GIA' AVUTA, 21/08 in chat:**
   *"L'HA POSTATO UN COLLEGA DEL CORSO"* + *"NON SO CHE INDICATORE SIA"*.
   Quindi: **provenienza = post in un gruppo del corso, autore ignoto, nessun
   numero dichiarato, nessuna documentazione.** Non e' un dettaglio: e' il
   fatto che decide come si tratta questo file (vedi §7).

---

## 6. 📌 QUELLO CHE NON SI PUO' ANCORA DIRE

- **Se funziona.** Nessun numero e' stato misurato da noi. Zero.
- **Se e' davvero diverso dal nostro ORB**, oltre ai quattro numeri: senza
  sorgente non e' escluso che sia lo stesso motore con altri parametri — e in
  quel caso, per la **regola della seconda caccia**, non entrerebbe
  nell'imbuto (*"MECCANISMI alternativi, MAI parametri diversi dello stesso
  motore"*).
- **Se i 17/24/33 valgono su BCM**: sono punti **assoluti**, quindi legati
  allo strumento e al broker di chi li ha scelti.


---

## 7. 🚩 LA PROVENIENZA CAMBIA LA CLASSIFICA — e non in meglio

_Aggiunto il 21/08 dopo la risposta di Claudio._

Provenienza accertata: **postato da un collega in un gruppo del corso.
Autore ignoto. Nessun referto, nessun numero dichiarato, nessuna spiegazione
dei quattro parametri.** Claudio stesso: *"NON SO CHE INDICATORE SIA"*.

Questo lo mette **in fondo alla coda**, non in cima, e per ragioni misurate in
casa, non per diffidenza:

1. **I quattro numeri (17 / 24 / 33 / le ore) non hanno origine.** Non sono
   *"[DICHIARATI DALL'AUTORE]"*: sono **anonimi**. Non si sa su quale
   strumento, quale broker, quale finestra e quale campione siano stati
   scelti — ne' se siano stati scelti o solo copiati. Un parametro senza
   provenienza vale **meno** di un parametro sbagliato ma tracciabile,
   perche' non si puo' nemmeno correggere.
2. **L'ora e' gia' sbagliata per BCM** (§3), e questo e' il primo indizio
   concreto che il file **non e' nato sul nostro broker**. Se le ore vengono
   da un altro broker, **anche i 17/24/33 vengono da un altro strumento**:
   sono punti **assoluti**, quindi non trasferibili.
3. **E' un INDICATORE, non una strategia.** Disegna livelli. Non dice
   **quando** entrare fra i due lati, **se** entrare, **quando** uscire se
   ne' TP ne' SL vengono toccati, **quanti** trade al giorno, cosa fare a fine
   giornata. Tutte cose che il nostro ORB ha scritte nel codice **e misurate**.
   Trasformarlo in EA vuol dire **inventare** quelle regole — e allora
   il motore sarebbe nostro, non suo.
4. **La regola della seconda caccia lo prende in pieno**: *"si cercano
   MECCANISMI alternativi sulla stessa inefficienza, MAI parametri diversi
   dello stesso motore"*. Stessa candela, stesso schema OCO, stesso mercato in
   apertura: finche' non si dimostra il contrario, **e' il nostro ORB con
   altri numeri.**

### ✅ L'UNICA COSA CHE PERO' RESTA VERAMENTE INTERESSANTE

**Lo stop FISSO con target 1:1.** Quella si' e' una differenza **strutturale**,
non di taratura — ed e' esattamente la direzione che **R55 aveva gia'
indicato da sola**, prima e indipendentemente da questo file:

> R55: *"l'ORB non muore di PF, muore di drawdown — e la causa e' lo stop
> STRETTISSIMO (50% del range): stop stretto = piu' lotti = ogni punto costa
> di piu'"*. `ORB_100K_CRITERI.md` punto D: **allargare lo stop**.

E c'e' gia' l'input per provarlo, dentro casa nostra: `InpSLBufferPts`
(v1.02, 19/08, nato per **R88**, gia' firmato).

> ### 🎯 CONCLUSIONE OPERATIVA
> **Non serve questo file per provare quell'idea** — e provarla col nostro EA
> e' **meglio**, perche' il confronto con la cella live e' a parita' di tutto
> il resto. Il valore del file di Diego non e' il file: e' la **conferma
> indipendente** che qualcun altro, sullo stesso mercato e sulla stessa
> candela, e' arrivato a stop fisso e 1:1.
>
> **Proposta (decide Claudio):** l'idea "stop fisso + target 1:1" entra nel
> round del Nasdaq come **cella da misurare col NOSTRO ORB**, non come EA
> nuovo da scrivere. Costo: quasi zero, gli input ci sono gia'.
> Il file di Diego resta agli atti come **fonte d'ispirazione citata**, non
> come motore candidato — e **non entra in forward in nessun caso**.
