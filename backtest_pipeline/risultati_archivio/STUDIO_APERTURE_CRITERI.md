# 🔬 STUDIO ANATOMIA APERTURE — 16 ANNI DI NASDAQ — CRITERI **FIRMATI**

> 🖊️ **FIRMA: "FIRMO LO STUDIO ANATOMIA CON PROPOSTE" — Claudio, 26/08/2026.**
> Tutte le decisioni del § 9 valgono con le proposte: definizioni congelate
> (DRIVE/FADE/RANGE/RIENTRO coi bordi esatti del § 2), cassaforte 2021-2026
> (le ipotesi di motore si scrivono SOLO su 2010-2020), soglie ai default
> dichiarati, dipendenza dall'esito misure lampo marcata in testa al referto.
> Firma a numeri non visti. Il lucchetto e' stato tolto dai due punti che lo
> portavano: la corsa vera (BLOCCO 2) ora parte.

> 🔒 **QUESTO DOCUMENTO PORTA IL LUCCHETTO DELLA FIRMA.** Il driver lo scarica
> **al pin** e ne cerca la parola-chiave **in tutto il file**: finché la trova, la
> **corsa vera** si ferma con `exit 2`. Il **giro a vuoto** parte lo stesso — non
> misura niente, e serve esattamente a far leggere questa pagina prima di firmarla.
> ⚠️ La parola del lucchetto **non è scritta in nessuna riga di prosa** di questa
> pagina, solo nel titolo e nel § 9: una citazione in prosa terrebbe la porta
> chiusa a firma data (checklist 82, pagata il 25/08 su R110).

**Origine**: Claudio, 26/08/2026 — _"creare agenti che da 0 analizzano gli ultimi
10 anni di trade su apertura del Nasdaq, Dax, Dow e in base al numero maggiore di
setup creino il motore giusto"_.
**Strumento**: `backtest_pipeline/anatomia_aperture.py` (marcatore `ANATOMIA_APERTURE_v1`).
**Driver**: `backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE.ps1` (marcatore `MARCATORE_RIGA_ANATOMIA_APERTURE_v1`).
**Riga da mandare**: `backtest_pipeline/righe/RIGA_ANATOMIA_APERTURE_DA_MANDARE.md`.
**Dati**: `C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv` — 5.233.590 barre M1,
2010.11.14 → 2026.07.31 (referto storico indici del 25/08, `REFERTO_STORICO_INDICI_RIGA1_20260825.txt`).

---

## 0. 📌 CHE COS'È — e soprattutto cosa **non** è

**È** la **FASE 1** di un lavoro in due tempi: si **misura** cosa fa il mercato
nell'ora d'apertura del Nasdaq, giorno per giorno, per sedici anni. Si contano i
**tipi di giornata** e si misura **quanto si muovono**.

**NON è:**

- ❌ **Non è un backtest.** In tutto questo round non compare — e non comparirà —
  un **profit factor**, un'**equity**, un **drawdown**, un **numero di trade**.
  Non ci sono spread, non ci sono fill, non ci sono costi, non c'è una posizione.
- ❌ **Non è un motore**, e non ne propone uno. Le ipotesi di motore sono la FASE 2
  e hanno criteri propri, da firmare a parte.
- ❌ **Non promuove niente e non spegne niente.** Nessuna sedia in forward viene
  toccata. Nessuna cella viene proposta.
- ❌ **Non è la Seconda Caccia** sul breakout d'apertura M5. Quella famiglia è
  morta sui numeri (§ 8) e questo studio **non la riesuma**: descrive il mercato,
  non riprova il motore bocciato con un'altra griglia.
- ❌ **Non tocca** R110, R111, lo STORICO, le MISURE LAMPO, FvgRetest, VwapRevert.

**Perché il verso è questo.** La domanda di Claudio (_"in base al numero maggiore
di setup creino il motore giusto"_) è, alla lettera, "guarda i dati e poi decidi
cosa fare". Fatta in un colpo solo su 16 anni, è la definizione di **curve
fitting**: si sceglie il motore che si adatta meglio a tutto lo storico e non
resta niente per verificarlo. Spezzata in due — **si misura prima, si ipotizza su
metà, si valida sull'altra metà mai vista** — la stessa domanda produce una
risposta verificabile. Il costo è un round in più. Il beneficio è che il verdetto
esiste.

---

## 1. 🧭 IL VINCOLO DELLE DUE FASI (è il cuore del round)

| | finestra | a cosa serve |
|---|---|---|
| **ADDESTRAMENTO** | **2010 → 2020** | **QUI** si guarda, e **qui** si scriveranno le ipotesi di motore (FASE 2) |
| **CASSAFORTE** | **2021 → 2026** | **NON si guarda** per costruire ipotesi. Serve a validarle **dopo** che sono congelate |

**Il vincolo è imposto dal codice, non dalla prosa**: lo strumento produce **tre
referti separati**, non uno.

- `ANATOMIA_APERTURE_IS_2010_2020.txt` — il file su cui si lavora
- `ANATOMIA_APERTURE_CASSAFORTE_2021_2026.txt` — la cassaforte, con l'avviso in testa
- `ANATOMIA_APERTURE_COMPLETO.txt` — il contesto, per leggere la storia

> ⚠️ **La cassaforte si produce lo stesso, e va detto perché.** Non produrla
> sembrerebbe più rigoroso ed è peggio: fra sei mesi qualcuno la rigenererebbe
> con uno strumento diverso e i due periodi non sarebbero più confrontabili.
> Si produce **ora, con lo stesso codice e lo stesso pin**, e si mette da parte.
> Chi la apre prima del tempo lo fa sapendo cosa sta facendo.

**Il taglio 2010-2020 / 2021-2026 non è pescato**: 2020 è l'ultimo anno prima
della finestra in cui gira il forward di casa, e lascia **undici anni** di
addestramento (~2.750 giorni di borsa) contro **sei** di validazione (~1.400).
L'**emendamento della finestra** del 16/08 chiede di dimensionare sulle
**operazioni**, non sugli anni: qui l'unità è il **giorno di borsa** e ce ne sono
migliaia da entrambe le parti, quindi la soglia dei 150 non morde. È il caso
comodo, e va detto che è comodo.

---

## 2. 🕐 IL FUSO — dedotto da una misura, e **contro la specifica del fornitore**

> ⚠️ **QUESTA È LA DECISIONE PIÙ CARICA DEL ROUND, E VA FIRMATA SAPENDO CHE COSA
> POGGIA SU CHE COSA.** Se l'ora è sbagliata, tutto lo studio misura un'altra
> cosa **con numeri perfettamente plausibili** — che è il modo peggiore di
> sbagliare. Quindi qui si scrivono **tutte e tre** le cose che si sanno,
> comprese quelle che remano contro.

**1. 📕 La specifica pubblica di HistData dice il CONTRARIO.** Agli atti, nel
nostro stesso repo (`backtest_pipeline/dukascopy/histdata_m1.py`, righe 81-84):
_«TimeZone: Eastern Standard Time (EST) time-zone **WITHOUT** Day Light Savings
adjustments»_. Presa alla lettera, `09:30` del file sarebbe l'apertura cash solo
d'inverno, e da **metà marzo a inizio novembre** (otto mesi su dodici, **non**
«metà anno») punterebbe **un'ora dopo** l'apertura vera.

**2. 📐 La misura di casa dice l'opposto, ed è una misura.** 8 import HistData su
8 hanno calibrato uno **shift fisso +5** contro lo storico nativo BCM, con
differenza media **0,0054-0,0110 %** su feed 2018-2024
(`REFERTO_IMPORT_6_SIMBOLI.md`). Il server BCM segue il DST **europeo**: se il
file fosse EST fisso lo scarto sarebbe **+5 d'inverno e +6 d'estate**, e nessuno
shift unico potrebbe dare quella differenza media su sette anni. Uno shift fisso
+5 è compatibile **solo** con timestamp in ora locale di New York.

**3. 🚧 Ma quegli 8 simboli sono FOREX E ORO — nessun indice.** Sono AUDJPY,
CHFJPY, EURJPY, GBPCAD, XAUUSD, USDJPY, EURUSD, GBPUSD. **`NASUSD` non è fra
questi**, e il suo CSV non è mai stato calibrato contro il nativo BCM (lo storico
BCM degli indici parte dal 26/09/2024). Quindi per **questo** file la convenzione
è **estrapolata**, non misurata: si assume che HistData applichi la stessa
convenzione a indici e forex.

➡️ **Perciò la misura diretta su questo file la fa il CANARINO, a ogni corsa** —
ed è per questo che esiste, e per questo si legge **per prima**. Finché il
canarino non parla, il fuso di `NASUSD_M1.csv` è una **deduzione**.

```
apertura cash Nasdaq = 09:30 NEW YORK = 14:30 ora server BCM = 15:30 italiana
```

- ➡️ **`-OraApertura` vale `09:30` e non si converte niente.** Chi passasse
  `14:30` misurerebbe il primo pomeriggio di New York. *(È il difetto che il
  verificatore ha appena pagato su `--estrai`: l'ora del referto d'import è in
  ora **server**, l'ora del CSV è in ora **New York**, e sono due cose diverse.)*
- ➡️ E lo strumento **non si fida nemmeno di questo**: il **CANARINO DEL FUSO**
  misura da solo, mese per mese, l'ora d'inizio della pausa giornaliera del feed
  e l'ora della riapertura di settimana. Se gennaio e luglio danno la stessa ora →
  il feed segue il DST → `09:30` è l'apertura **tutto l'anno**. Se luglio scivola
  di un'ora → **EST FISSO**, e allora **otto mesi su dodici** sarebbero misurati
  fuori bersaglio: lo strumento **lo dichiara e alza il codice d'uscita**, non
  tira dritto.
- ➡️ Le due misure sono **indipendenti** e il referto le tiene separate: se si
  muovono **tutte e due** non è una transizione storta, **è il fuso**, e lo
  strumento lo scrive con una riga sua. Se se ne muove **una sola**, va guardata
  quella transizione — non si conclude niente sul fuso.
- ⚠️ **Il canarino si legge PRIMA di ogni altra cosa.** Se dice EST FISSO, tutto
  il resto del referto non si legge: si rifà.

---

## 3. 📏 LE DEFINIZIONI, CONGELATE PRIMA DI GUARDARE I NUMERI

Tutte meccaniche, nessuna discrezione. Tutte le soglie sono **input** dello
strumento: qui c'è il valore di partenza **e il motivo**.

### 3.1 I pezzi della giornata

| pezzo | definizione |
|---|---|
| **apertura** | `Open` della barra delle **09:30** (ora del file) |
| **pre-apertura** | massimo e minimo dei **60 minuti prima** (08:30–09:29) |
| **gap** | apertura − **ultima chiusura cash precedente** = ultima barra con orario ≤ **16:00** del giorno di borsa prima |
| **range di riferimento** | massimo e minimo dei primi **15 minuti** |
| **finestra di giudizio** | i primi **60 minuti** |
| **finestre di misura** | **5 / 15 / 30 / 60** minuti |

> La finestra del gap guarda **le 5 ore prima delle 16:00**, non l'ultima ora: i
> giorni di mezza seduta (vigilia di Natale, venerdì dopo il Ringraziamento)
> chiudono alle **13:00**, e con una finestra stretta il gap del giorno dopo
> sarebbe `n/d` proprio nei giorni più particolari.
> ⚠️ **Effetto collaterale dichiarato**: il feed è 24h, quindi in una festa di
> borsa americana possono esserci barre sottili. In quel caso il riferimento del
> gap è l'ultimo prezzo battuto in una sessione **rada**, non una chiusura cash
> vera. Per questo il CSV porta la colonna **`data_chiusura_prec`**: il
> riferimento di ogni gap è **scritto e verificabile**, non implicito.

### 3.2 Le escursioni

**Sempre dal PREZZO D'APERTURA**, in **punti indice** e in **% del prezzo**.

> 🔑 **Il % è l'unico metro confrontabile su 16 anni.** Il Nasdaq apre a **2.135**
> nel 2010 e a **28.272** nel 2026: una soglia in punti non è la stessa soglia
> alle due estremità del campione. Ogni numero di questo studio che serve a
> **confrontare** è in percentuale; i punti si stampano accanto solo per avere il
> senso della grandezza.

> «Favorevole» e «contraria» **non esistono senza una posizione**. Il CSV misura
> **SU** e **GIÙ**, che sono fatti; il referto, quando aggrega **per classe**, usa
> la direzione della classe (per un DRIVE-UP il favorevole è il SU) e lo dichiara.

### 3.3 La classificazione del giorno — e la sua convenzione di nome

> 🏷️ **IL SUFFISSO NOMINA SEMPRE IL LATO DELLA ROTTURA.** Sempre, in tutte e
> quattro le classi direzionali. È l'unica convenzione senza ambiguità, e senza
> dichiararla `FADE-UP` può voler dire due cose opposte.

| classe | definizione meccanica |
|---|---|
| **DRIVE-UP** | rompe **al rialzo** dopo il minuto 15 **e** chiude la finestra sopra il massimo del range di rif. + margine |
| **DRIVE-DOWN** | rompe **al ribasso** e chiude sotto il minimo − margine |
| **FADE-UP** | rompe **al rialzo** e chiude **SOTTO** il minimo − margine *(la rottura rialzista è stata rimangiata)* |
| **FADE-DOWN** | rompe **al ribasso** e chiude **SOPRA** il massimo + margine |
| **RANGE** | non rompe da nessuno dei due lati |
| **RIENTRO** | rompe, ma chiude **dentro** il range di riferimento |

**Cascata deterministica**: `RANGE → FADE → DRIVE → RIENTRO`.

⚠️ **La sesta classe esiste apposta.** `RIENTRO` non era nell'elenco della
richiesta, ed è il caso più frequente in qualunque serie reale: un giorno che
rompe e poi torna dentro. Senza una casella sua finirebbe schiacciato dentro
`RANGE` o dentro un `DRIVE`, cioè un errore **plausibile** — il tipo peggiore.

⚠️ **I giorni che rompono da TUTTI E DUE i lati.** Vince la regola del **FADE**
(una rottura rimangiata dice più di una riuscita) — **quando la chiusura è oltre
uno dei due bordi**. Se invece un giorno a due lati chiude **dentro** il range di
riferimento, nessun `FADE` si applica e la cascata lo porta in `RIENTRO`: è la
casella giusta, ed è verificato riga per riga. In tutti e tre i casi il giorno
porta la bandiera
**`DUE_LATI = 1`** nel CSV. **Il referto li conta in una colonna sua**: così il
peso di questa regola di priorità si **misura** invece di restare una scelta
nascosta. Se quella colonna è grossa, la regola va discussa — e allora sarà una
discussione sui numeri.

### 3.4 Il margine di rottura

```
margine = max( K x ampiezza del range di riferimento ;  P% del prezzo d'apertura )
```

| input | default | perché |
|---|---|---|
| `--k-margine` | **0,10** | la rottura si misura sulla **volatilità del giorno**: superare il bordo del 10% dell'ampiezza dei primi 15' è "essere fuori", un tick no |
| `--pavimento-pct` | **0,02 %** | serve un **pavimento**: con un range di riferimento quasi nullo (apertura morta) qualunque tick sarebbe "rottura". Sul Nasdaq a 20.000 sono 4 punti; a 2.135 (2010) sono 0,43 punti — la stessa cosa, scalata |

Nessuno dei due è pescato da un backtest: **non c'è nessun backtest da cui
pescarli**, ed è il vantaggio di misurare prima di ottimizzare.

> 🔬 **I BORDI, dichiarati** (perché una definizione che non dice cosa succede
> *esattamente sulla soglia* non è meccanica): la rottura è `>=` — toccare
> **esattamente** `bordo + margine` **è** rottura; e la banda morta della
> persistenza è **esclusiva** — un movimento pari **esattamente** a
> `deadband_pct` è **PIATTO**, non una direzione. Verificato eseguendo, sui
> valori di confine e a un tick da entrambi i lati.

### 3.5 La persistenza

> Domanda: **la direzione dei primi 15 minuti continua fino al minuto 60?**

`direzione dei primi 15'` = segno di (chiusura 15' − apertura), con **banda morta**
`--deadband-pct` = **0,05 %** del prezzo (sotto, non è una direzione: è rumore, e
chiamarla "su" o "giù" gonfierebbe il campione con giornate piatte).
**PERSISTE** = la chiusura a 60' è **più avanti nello stesso verso** della
chiusura a 15'. Si riporta anche l'**estensione mediana** (quanto ancora si muove).

---

## 4. 🩺 IL CANCELLO QUALITÀ DEL FEED — dichiarato, e misurato dentro allo studio

Le **MISURE LAMPO** del cancello `_EXT` (26/08, `RIGA_MISURE_LAMPO.ps1`) stanno
esaminando **tre eventi anomali**, e il **cancello ZERO è ancora CHIUSO**: diff
media H1 misurata **0,061–0,101 %** contro il **≤ 0,05 %** richiesto
(`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md`).

Tre decisioni, prese qui e scritte prima:

1. **Lo studio GIRA LO STESSO.** È descrittivo e non autorizza niente: non
   promuove celle, non muove sedie, non firma. Aspettare gli toglierebbe il suo
   unico rischio (nessuno) senza dargli niente.
2. **Ogni referto lo dice in testa**: l'**interpretazione** di questi numeri
   dipende dall'esito di quelle misure. Se il feed risultasse malato in un
   periodo, i conteggi di quel periodo **si rileggono**, non si riusano com'erano.
3. **Lo studio misura da solo quanto pesa la malattia.** I giorni con copertura
   oraria anomala sono **esclusi dai conteggi** e **contati a parte**.

### 4.1 GIORNO SOSPETTO — la definizione, e le soglie col loro motivo

Un giorno è **SOSPETTO** (escluso dalle distribuzioni, contato nella colonna
`SOSPETTI`) se **almeno una**:

| condizione | input | default | perché |
|---|---|---|---|
| poche barre nell'ora d'apertura | `--min-barre-ora` | **55** su 60 | tollera fino a 5 minuti mancanti (~8%). Sotto, l'escursione massima dell'ora non è più la stessa misura: manca il pezzo dove poteva stare |
| un buco interno troppo largo | `--max-buco-min` | **3** minuti | un buco di 4+ minuti dentro i primi 60' può nascondere **proprio l'estremo** che si sta misurando |
| manca la barra dell'apertura | — | — | il **prezzo d'apertura non è osservato**: tutto il resto è misurato da un riferimento inventato. Si ripiega sulla prima barra dei primi 5 minuti **e lo si dichiara**, giorno per giorno |

Un giorno **SENZA APERTURA** (nessuna barra nei primi 5 minuti) non è un giorno di
borsa misurabile: feste, weekend, buchi di feed. Conta in una colonna sua, e il
referto **spacca per giorno della settimana** — le domeniche ci stanno
legittimamente (feed 24h), un mucchio di **infrasettimanali** lì dentro sarebbe
invece un buco di feed.

La copertura della **pre-apertura** (`--min-barre-pre`, default **30** su 60) è
**solo informativa** e **non esclude** il giorno: il gap e il range pre restano
leggibili anche con la pre-apertura sottile, e la misura che conta vive nell'ora
**dopo** l'apertura.

**Se in un anno i sospetti superano `--quota-sospetti` = 20 %**, il referto alza un
**RILIEVO** con nome e cognome dell'anno **e lo strumento esce con 1**. Non ferma
niente: dichiara — ma lo dichiara anche al **codice d'uscita**, non solo dentro a
un file. *(Il 26/08 questo rilievo viveva solo nel testo del referto: un anno al
38,7 % di giorni malati usciva **0** e la riga di lancio stampava «ESITO: OK».
Trovato in verifica, riprodotto, corretto — e adesso c'è la prova 13
dell'autotest che lo tiene fermo.)*

> 📐 **Il denominatore della quota, dichiarato**: `SOSPETTI / (BUONI + SOSPETTI)`,
> cioè sui giorni **MISURABILI** — **non** sui giorni di calendario. I giorni
> `SENZA APERTURA` (feste, domeniche del feed 24 h) **non entrano sotto**:
> contarli diluirebbe la quota proprio negli anni con più buchi, cioè
> spegnerebbe l'allarme dove serve di più. Il referto stampa la formula accanto
> alla colonna `%SOSPETTI`.

---

## 5. 🧪 IGIENE DEL DATO — le assunzioni si misurano

| assunzione | come viene trattata |
|---|---|
| «il file è ordinato per tempo» | **misurata**: le righe fuori ordine si **contano** e finiscono nel referto. Non si riordina alla cieca (checklist 81) |
| «una barra per minuto» | le barre della finestra d'apertura sono indicizzate **per minuto**, che è una **chiave unica**: nessun pari da sciogliere. I duplicati si contano e si tiene **il primo**, dichiarato |
| «il file è quello giusto» | il formato si riconosce **aprendo il file**, mai dal nome (checklist 83). Due strumenti di casa scrivono `<SIMBOLO>_M1.csv` in **due formati diversi**, e lo strumento distingue *«il file non c'è»* da *«il file c'è ma è dell'altro gemello»* con **due messaggi diversi** |
| «esiste una copia sola» | il driver **censisce tutti i candidati** e dichiara **quale usa e perché**. Qui serve la copia **più LUNGA** (16 anni) — è il verso **opposto** alle misure lampo del 26/08, dove serviva la più corta |
| «la RAM basta» | **misurata**: lo strumento legge in **streaming** e non tiene le barre in memoria. Misurato su un file sintetico delle dimensioni vere (5,95 M barre, 386 MB): **14 secondi, 33 MB di picco** — contro i ~3,6 GB che costerebbe il metro dei 690 byte/barra (checklist 74) |

---

## 6. 📤 COSA PRODUCE

| artefatto | contenuto |
|---|---|
| `ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv` | **una riga per giorno di calendario presente nel file**: data, giorno della settimana, regime, fase, stato (OK/SOSPETTO/SENZA_APERTURA) e **motivo**, copertura, gap, range pre, range di rif., margine, **classe**, `DUE_LATI`, direzione e persistenza, e per **ogni** finestra 5/15/30/60 l'escursione SU, GIÙ e la chiusura, in punti **e** in % |
| `ANATOMIA_APERTURE_IS_2010_2020.txt` | il referto dell'**addestramento** |
| `ANATOMIA_APERTURE_CASSAFORTE_2021_2026.txt` | la **cassaforte** |
| `ANATOMIA_APERTURE_COMPLETO.txt` | il contesto |
| `CENSIMENTO_FONTE.txt` | ogni candidato aperto, con formato, dimensione, data, prima e ultima riga |
| `REFERTO_ANATOMIA_APERTURE.txt` | il referto del **driver**: fonte, fuso, stato dei criteri, righe chiave, attesi vs trovati, NOTE e PROBLEMI |

Ogni referto contiene: **canarino del fuso** (mese per mese) · **copertura e
giorni sospetti per anno** · **distribuzione delle classi per anno e per regime**
· **escursioni mediane per classe** (con i quartili sulle due classi di spinta) ·
**il movimento grezzo finestra per finestra** · **persistenza** · **le classi
condizionate al gap**.

> 🏷️ **UNA SOLA CONVENZIONE DI SENTINELLA, e vale in tutti e due i posti.**
> Nei **referti**: `n/d` = **non misurato**, mai uno zero. Nel **CSV**: il campo
> non misurato è **VUOTO**, mai zero. Chi apre il CSV con un foglio di calcolo o
> con `Import-Csv` deve leggere la cella vuota come *non misurato*: su un gap o
> su un'escursione, **lo zero sarebbe un numero perfettamente plausibile** — ed è
> il refuso peggiore (checklist 66).

**I regimi sono un'ETICHETTA DI CALENDARIO, non una misura**: `2010-2019` /
`2020 covid` / `2021` / `2022 orso` / `2023-2026`. Nessuno ha datato le fasi di
mercato barra per barra, e va letto così.

---

## 7. 🚦 I CANCELLI DI QUESTO ROUND

- **G1 — campione** (`--min-giorni-anno`, default **150**): la distribuzione di un
  anno si legge solo con **≥ 150 giorni buoni** in quell'anno.
  ✅ **È imposto dal CODICE, non solo scritto qui**: il referto marca la riga con
  `<-- SOTTO G1: NON LEGGIBILE` ed elenca gli anni bocciati sotto la tabella. La
  riga **si stampa lo stesso** (nessun gruppo sparisce), ma le sue percentuali
  **non si citano**. *(Verificato eseguendo: il **2010** ci finisce, ed è atteso —
  è un moncone di novembre-dicembre, ~35 giorni.)*
- **G2 — il canarino del fuso deve essere verde.** Rosso ⇒ il resto non si legge.
- **G3 — nessuna promozione, nessuna firma, nessun cambio in forward.** Sempre.
- **G4 — nessuna ipotesi di motore scritta guardando la cassaforte.** È il vincolo
  del § 1, e il referto lo ripete a ogni corsa perché è l'unico che può essere
  violato **in silenzio**.
- **G5 — nessun PF, nessuna equity, nessun DD, nessun conteggio di trade.** Se un
  numero del genere comparisse in un referto di questo round, il referto è sbagliato.

---

## 8. ⚰️ I CADUTI CHE QUESTO ROUND NON RIESUMA

Prima di guardare qualunque numero, agli atti c'è già questo — e serve a non
riproporre domani, con entusiasmo, una cosa già morta:

| motore | verdetto | dove |
|---|---|---|
| **breakout M5 in apertura** | *«capitolo BREAKOUT M5 CHIUSO»* (26/07): Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB — tutti morti a tick reali | `REGISTRO_TEST.md` § 1-2 |
| **Nasdaq apertura STOP** | PF 0,88 nudo · **0,82 a tick reali**, 0% pass positivi, DD 17% | `CACCIA_MOTORE_APERTURE.md` |
| **RETEST** (limit sul livello rotto) | 0,73 su Nasdaq, DD 27%: **selezione avversa** sui falsi break | id. |
| **RANGE-FADE** | sul DAX **0/136 pass sopra PF 1**, DD mediano 23,5% | id. |
| **entrata ritardata a orario fisso** | **29 configurazioni, tutte sotto 1** | id. |
| **lati SHORT delle aperture (R45, R107)** | **0 su 3** al cancello del merito | `R107_REFERTO.md` |

> 🎯 **A cosa serve allora questo studio, se il motore è morto?** A rispondere a
> una domanda **diversa**, che non è mai stata posta: *quei motori morivano perché
> l'apertura del Nasdaq non ha struttura, o perché avevamo scelto la struttura
> sbagliata?* Le due cose si distinguono **contando i giorni**, non provando una
> quarta griglia sullo stesso motore. È esattamente la **regola della seconda
> caccia** (19/08): si cercano **meccanismi** alternativi sulla stessa
> inefficienza, mai parametri diversi di un motore morto — e prima di cercare
> meccanismi bisogna sapere **che forma ha il fenomeno**.
> ⚠️ E se i conteggi dicessero *"non c'è nessuna classe dominante, sono tutte
> equiprobabili"*, **quello è un risultato** e chiude la questione meglio di altri
> dieci backtest.

---

## 9. ✍️ LE DECISIONI — **FIRMATE ("FIRMO LO STUDIO ANATOMIA CON PROPOSTE", 26/08/2026)**

| # | decisione | proposta |
|---|---|---|
| **D1** | **simbolo** | **solo NASUSD** in questo round. DAX e Dow sono round a sé: HistData **non ha il Dow**, e `grxeur` è **BOCCIATO in attesa di diagnosi** (decisione D-F del 25/08). Prometterli qui sarebbe una promessa che i dati non mantengono |
| **D2** | **finestra** | **2010.11 → 2026.07**, tutto lo storico disponibile |
| **D3** | **taglio delle due fasi** | addestramento **≤ 2020**, cassaforte **≥ 2021** |
| **D4** | **soglie di classificazione** | `K = 0,10` · pavimento `0,02 %` · banda morta `0,05 %` (§ 3.4-3.5) |
| **D5** | **soglie dei giorni sospetti** | `55/60` barre · buco max `3` min · quota d'allarme `20 %` (§ 4.1) |
| **D6** | **la sesta classe** | `RIENTRO` esiste come classe propria, e i giorni a **due lati** portano una bandiera contata a parte (§ 3.3) |
| **D7** | **uso** | **SOLO ANATOMIA**: nessun motore, nessuna promozione, nessuna firma di celle. Le ipotesi sono un round separato con criteri propri |

---

## 10. 📖 COME SI LEGGERÀ IL RISULTATO (scritto **prima** di vederlo)

1. **Prima il canarino del fuso.** Rosso ⇒ ci si ferma, il resto è misurato un'ora
   fuori bersaglio per metà anno.
2. **Poi la copertura.** Un anno con molti sospetti vale meno: è la malattia del
   feed, misurata. La colonna `SOSPETTI` è il termometro del cancello in verifica.
3. **Poi la distribuzione delle classi** del referto di addestramento. È la
   risposta letterale alla domanda di Claudio: *quale setup si presenta di più*.
4. ⚠️ **Una classe frequente NON è un edge: è una frequenza.** Se il 40% dei
   giorni è `RIENTRO`, non vuol dire che fadare le rotture paghi: vuol dire che le
   rotture rientrano spesso. Se paghi lo dicono spread, stop e fill — cioè la
   **FASE 2**, con i tick BCM.
5. **Le escursioni mediane per classe** dicono se quel movimento è **abbastanza
   grande** perché valga la pena parlarne. Metro grezzo già agli atti: sul DAX in
   apertura uno stop da 41 punti veniva preso dallo scossone iniziale, e un
   trailing da 4,1 punti chiudeva in 39 secondi (03/08). Un movimento mediano che
   non supera di parecchie volte lo spread **non è un candidato**, comunque sia
   frequente.
6. **La colonna `2LATI`** dice quanto pesa la regola di priorità della cascata.
7. **La persistenza** dice se il movimento dei primi 15' è informazione o rumore.

---

## 11. 🔭 QUELLO CHE QUESTO STUDIO NON POTRÀ DIRE

- Se un motore **guadagnerebbe**. Niente spread, niente fill, niente costi,
  nessuna posizione.
- Niente su **DAX e Dow** (D1).
- I dati sono **HistData, non BCM**: spread, orari di seduta e prezzi non sono
  quelli su cui si opera. Un'anatomia del feed esterno descrive il **mercato**,
  non il **conto**.
- Se il cancello qualità chiudesse male, **una parte di questi conteggi andrà
  riletta**. È scritto in testa a ogni referto apposta.
