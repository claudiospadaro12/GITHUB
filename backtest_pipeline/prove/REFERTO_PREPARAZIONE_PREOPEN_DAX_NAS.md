# 🧾 REFERTO DI PREPARAZIONE — **PREOPEN DAX** e **PREOPEN NAS**

_28/08/2026 — preparazione, **non** una corsa. **Nessun numero di mercato è stato
misurato in questo documento**: qui non c'è MT5, e niente è girato sul banco._

Sono i **due gemelli** del round `PREOPEN DOW` preparato stamattina: stesso
interruttore mai acceso (`InpRangeMode=1`, il livello dal **range pre-apertura**),
stessa forma, **stessi criteri**, altri due mercati.

---

## 🛑 LE DUE COSE PIÙ IMPORTANTI, IN CIMA

> ### 1️⃣ **Il DAX ha DUE sedie vive, non una — e la seconda gioca già questo livello**
>
> `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (magic **`770411`**) usa un **box
> notturno 23:00-04:59 server**, piazza ordini **STOP alle 07:59**, con **cutoff
> ingressi alle 08:30**, ed è **SHORT ONLY** — tutto **letto nel sorgente oggi**
> (`..._MFE.mq5`, righe 71-74 / 79-80 / 81-82 / 91-92).
> Il rischio di **doppione** col candidato `InpRangeMode=1` sul DAX è **ALTO**, ed
> è ora **quantificato di calendario** (tabella nel §4). **La misura vera — le
> giornate in comune — è il passo successivo dichiarato, e NON è in questo round.**
>
> ### 2️⃣ **La sedia Nasdaq è SPENTA, con QUATTRO verdetti negativi agli atti**
>
> `ABTG_Nasdaq_Apertura_US` (magic **`770201`**) è **spenta dal 18/08/2026 alle
> 09:41** (FIRMA 5) ed è l'unica sedia che il censimento marca **🔴 SENZA
> CONTRATTO**. ⚠️ **Il mandato di questo lavoro la chiamava "magic vivo 770201":
> è un errore, e va corretto agli atti prima di leggere qualunque numero.**
> Conseguenza: quel round non è un tentativo di riaccendere una sedia, è **una
> porta che si chiude con un numero** — ed è preparato con quel cartello in cima.

📬 **I blocchi da incollare stanno in DUE pagine, e sono quelle le fonti vive:**
### 👉 `backtest_pipeline/righe/RIGA_PREOPEN_DAX_DA_MANDARE.md`
### 👉 `backtest_pipeline/righe/RIGA_PREOPEN_NAS_DA_MANDARE.md`

_(Qui **non** c'è nessuna copia dei blocchi di lancio, ed è voluto: un domani un
fix cambia il pin nelle pagine e una copia incollata in un referto resterebbe per
sempre alla versione vecchia — funzionante e sbagliata. **CHECKLIST punto 100**,
pagato ieri su `REFERTO_PREPARAZIONE_KSQFVG.md`.)_

---

## 1. 🔧 Zero codice EA scritto — ed è il punto, per la terza volta

Né `ABTG_DAX_Apertura_EU.mq5` né `ABTG_Nasdaq_Apertura_US.mq5` sono stati
toccati. L'interruttore esiste **dal primo giorno** in tutti e tre gli EA della
famiglia:

| EA | enum a 3 rami | `ComputeLevels` | `OpeningBodyDir` |
|---|---|---|---|
| `ABTG_DAX_Apertura_EU.mq5` | righe **221-223** | **978-981** | 1179-1186 |
| `ABTG_Nasdaq_Apertura_US.mq5` | righe **176-178** | **869-872** | 1077-1084 |

Con `InpRangeMode = ABTG_RANGE_PREV (1)` la finestra del livello è
`openMin − InpPrevWindowMin … openMin`, cioè **esattamente il pre-market range**.

**Conteggio fatto nel repo, non ipotizzato** (caccia del 28/08, grep su
`backtest_pipeline/prove/`): **tutti e 23** i file prova DAX pinnano
`InpRangeMode=0`; sul Nasdaq è sempre **0 oppure 2**, **mai 1**. Gli unici file
al mondo che lo pinnavano a 1 erano i `PREOPEN_*_DOW_M15*` nati stamattina.

📌 **Il fatto meccanico che vale la pena sapere prima**, e che **NON è uguale sui
tre mercati**: con `RangeMode=1` il retest si arma all'**apertura** invece che
`+InpRangeMinutes`, perché `refEndMin` diventa `openMin`. La finestra operativa
si allunga di **35 minuti** — ma quanto pesa dipende da quanto è lunga:

| mercato | candidato arma | riferimento arma | finestra | delta |
|---|---|---|---|---|
| **Dow** | 14:30 | 15:05 | 3h00 vs 2h25 | **+24%** |
| **Nasdaq** | 14:30 | 15:05 | 3h00 vs 2h25 | **+24%** ← caso peggiore |
| **DAX** | 08:00 | 08:35 | 9h30 vs 8h55 | **+6,5%** ← molto più mite |

Parte del delta che i round misureranno **non è "il livello", è "più tempo"**.
Ogni driver lo stampa accanto a ogni verdetto `PASSA`.

---

## 2. 📁 Cosa ho preparato — 14 artefatti

### 🇩🇪 DAX (`D30EUR`, M15)

| file | ruolo | magic |
|---|---|---|
| `prove/PREOPEN_RETEST_DAX_M15.txt` | **la griglia LONG e I CRITERI** | `781600/781601` |
| `prove/PREOPEN_RETEST_DAX_M15_SHORT.txt` | gemello SHORT (regola dei due lati) | `781700/781701` |
| `prove/PREOPEN_METRO_DAX_M15.txt` | **METRO 0c** su M15, lato long | `781800/781801` |
| `prove/PREOPEN_METRO_DAX_M15_SHORT.txt` | **METRO 0c** su M15, lato short | `781900/781901` |
| `prove/PREOPEN_COSTO_DAX_M15.txt` | cella del **cancello del costo** (0b) | `782000/782001` |
| `righe/RIGA_PREOPEN_DAX.ps1` | il driver (`MARCATORE_RIGA_PREOPEN_DAX_v1`) | — |
| `righe/RIGA_PREOPEN_DAX_DA_MANDARE.md` | **la pagina di lancio — unica fonte viva** | — |

### 🇺🇸 NASDAQ (`NASUSD`, M15)

| file | ruolo | magic |
|---|---|---|
| `prove/PREOPEN_RETEST_NAS_M15.txt` | **la griglia LONG e I CRITERI** | `782100/782101` |
| `prove/PREOPEN_RETEST_NAS_M15_SHORT.txt` | gemello SHORT | `782200/782201` |
| `prove/PREOPEN_RIF_NAS_M15.txt` | **RIFERIMENTO 0c** su M15, lato long | `782300/782301` |
| `prove/PREOPEN_RIF_NAS_M15_SHORT.txt` | **RIFERIMENTO 0c** su M15, lato short | `782400/782401` |
| `prove/PREOPEN_COSTO_NAS_M15.txt` | cella del **cancello del costo** (0b) | `782500/782501` |
| `righe/RIGA_PREOPEN_NAS.ps1` | il driver (`MARCATORE_RIGA_PREOPEN_NAS_v1`) | — |
| `righe/RIGA_PREOPEN_NAS_DA_MANDARE.md` | **la pagina di lancio — unica fonte viva** | — |

### 🧬 I file prova sono **gemelli VERIFICATI**, e non sono stati ribattuti

I quattro gemelli di ogni famiglia sono stati **GENERATI dal file LONG** con uno
script che **asserisce** ogni sostituzione, poi il diff è stato **letto**:

| confronto | righe che differiscono | atteso |
|---|---|---|
| LONG ↔ SHORT | `InpAllowLong`, `InpAllowShort`, `InpMagic` | ✅ |
| LONG ↔ METRO/RIF long | `InpRangeMode`, `InpPrevWindowMin`, `InpMagic` | ✅ |
| SHORT ↔ METRO/RIF short | `InpRangeMode`, `InpPrevWindowMin`, `InpMagic` | ✅ |
| METRO/RIF long ↔ short | `InpAllowLong`, `InpAllowShort`, `InpMagic` | ✅ |
| LONG ↔ COSTO | `InpPrevWindowMin`, `InpRetestOffsetPts`, `InpMagic` | ✅ |

Conteggio parametri: **73 per file sul DAX**, **87 per file sul Nasdaq** (i 73
del DAX **meno** `InpAllowReverse`, **più** i **15 del blocco R30**:
73 − 1 + 15 = 87. `InpLevelTF` c'è in **tutti e due** i file e non entra nel
conto).
**E il driver lo ri-verifica da solo prima di aprire MT5** (gate della stella,
confronto **per nome** e non per posizione).

### ✅ Nessun parametro orfano — verificato con lo strumento di casa

```
python3 backtest_pipeline/controlla_prova.py --ea <EA>.mq5 <i 5 file>
  DAX:  pin=73 su tutti e 5   NAS: pin=87 su tutti e 5   → zero "parametri che l'EA non ha"
```

⚠️ **`controlla_prova.py` esce comunque con codice 1**, con il rilievo
*«3 assi Y: un file prova misura UNA variabile alla volta»*. **Non è un difetto
nuovo**: i file del **Dow** danno **lo stesso identico rilievo** (verificato
eseguendolo su di loro). È una regola dello strumento che questo tipo di round —
uno **screening a due assi** — viola per costruzione e per progetto.

---

## 3. 🎯 Da dove viene ogni valore — e le tre differenze che NON sono copie

### DAX — la baseline è `R101_DAX_00_viva`, cioè **la sedia viva**

Numeri agli atti (M5, **stessa finestra e stesso split** di questo round, tick
reali, deposito 100.000, rischio 1% — `R101_REFERTO.md` §2, riprodotti al
millesimo anche da R107 come gate G0):

| | IS | OOS |
|---|---|---|
| **DAX long (viva)** | +3.789 · PF 1,126 · DD 5,44% · n 175 | **+18.030 · PF 1,397 · DD 7,23% · n 270** |
| **DAX short (R107)** | −996 · PF 0,965 · n 138 | **−1.865 · PF 0,957 · DD 12,31% · n 257** |

### 🔴 Tre differenze rispetto al Dow che ho dovuto DECIDERE, non copiare

| # | cosa | Dow | DAX | perché ho scelto così |
|---|---|---|---|---|
| **1** | `InpMinStopPts` / `InpSkipIfTight` | 500 / 0 | **0 / 1** | Sono i valori **della sedia viva DAX**, e il suo contratto (DD 6,25% R16 / 7,23% R46) è stato misurato **così**. Mettere il pavimento del Dow cambierebbe **due cose insieme** (livello **e** stop) e renderebbe **illeggibile** il confronto col metro. 🔴 **È l'interpretazione più discutibile del giro, ed è nella pagina come punto 4 da approvare.** Il rischio residuo (lotto contro `VOLUME_MIN`/`MAX`, DD che sottostimano) è dichiarato `[DA VERIFICARE]` |
| **2** | filtro EMA | **acceso** (H4) | **spento** | È la sedia viva. Conseguenza pesante: **sul DAX il lato short ENTRA davvero** (n OOS 257), mentre sul Dow quasi non entra (73). La domanda del gemello short cambia di conseguenza (vedi sotto) |
| **3** | `InpAllowReverse` | **non esiste** | pinnato **0** | Input R51 che esiste **solo** nel DAX. A 1 il retest farebbe **due cicli al giorno** (tetto rigido, riga 637): sarebbe **un altro motore**, non un altro livello. Il driver lo impone con un gate, e il gate **è stato fatto scattare** |

### 🎯 E la conseguenza sul LATO SHORT del DAX, che va scritta prima dei numeri

R107 ha **già misurato** il lato short del DAX in apertura **con campione pieno
(n 257)** e il verdetto agli atti è **«NIENTE EDGE, e stavolta è misurato»** —
rosso **anche nell'IS**, che contiene la discesa feb-apr 2025.

👉 **Il gemello short di questo round non chiede «c'è edge?»** (risposta già
data). Chiede: **«cambiare il LIVELLO resuscita un lato già bocciato con
campione pieno?»**. **Onere della prova più alto, non più basso.**

### Nasdaq — la baseline è `R107_NAS_00_riflong`, che **NON è un metro**

Non esiste una sedia viva con questa geometria: la 770201 è spenta. Quindi ho
ripreso, **parola per parola**, la scelta di R107:

- il file si chiama **`PREOPEN_RIF_NAS_M15.txt`**, la fase si chiama **`RIF`**,
  e nel referto la parola è **RIFERIMENTO**;
- 🔴 **in quel round NON C'È NESSUN GATE G0**: da quelle righe **non si può
  concludere che il banco sia sano**. Il driver lo stampa come cappello n. 3 del
  verdetto;
- la geometria è **quella viva del Dow TRASPOSTA**, e il limite è
  pre-dichiarato: buffer e offset sono in **punti assoluti** su scale diverse
  (10 punti indice = 0,023% sul Dow, **0,05%** sul Nasdaq). Se le celle escono
  rosse, il risultato è *«il livello non salva la geometria trasposta»*, **non**
  *«il Nasdaq non ha edge in apertura»*.

Numeri agli atti (R107, M5, stessa finestra e split):

| | IS | OOS |
|---|---|---|
| **NAS long (rif.)** | +1.371 · PF 1,080 · n 85 | +1.873 · PF 1,110 · DD 5,62% · n 113 |
| **NAS short** | +8.399 · PF **3,220** · n 58 | **−10.569 · PF 0,460** · DD 11,34% · n 59 |

📉 **Campione sottile**: 113 e 59 op OOS stanno **sotto le 150** dell'Emendamento
A → su questa famiglia il **MERITO resta SOSPESO per campione** (è lo stesso
cancello G4 con cui R107 ha letto il Nasdaq). Il **RISCHIO** no: quello si
giudica sempre.

---

## 4. 🚨 IL DOPPIONE SUL DAX — quantificato di calendario, **non misurato**

Il candidato arma alle **08:00** sul max/min di
`[08:00 − InpPrevWindowMin, 08:00)`. Il box della sedia viva `770411` è
**23:00-04:59** server. **La sovrapposizione si calcola** — e il driver la
stampa nel referto (numeri **prodotti eseguendo il driver**, non scritti a mano):

| `prevWin` | finestra del livello | minuti dentro il box |
|---:|---|---:|
| 60 | 07:00 – 08:00 | **0** |
| 120 | 06:00 – 08:00 | **0** |
| 180 | 05:00 – 08:00 | **0** _(confina di un minuto)_ |
| 240 | 04:00 – 08:00 | **60** (16,7% del box) |
| 300 | 03:00 – 08:00 | **120** (33,3% del box) |

**Tre conseguenze, tutte nella pagina di lancio e nel file prova:**

1. le **due celle larghe** (240, 300) costruiscono il livello **dentro il box
   della sedia viva**: se vincono loro, il sospetto è **strutturale**;
2. 🎯 **il rischio è ASIMMETRICO**: la `770411` è **SHORT ONLY** → sul lato
   **LONG** un doppione **di lato non può esistere**; sul lato **SHORT** è il
   caso peggiore possibile;
3. i **grilletti** restano diversi (rottura/STOP contro retest/LIMIT): diverso il
   prezzo di riempimento, **non necessariamente diverse le giornate** — e per il
   drawdown della prop **contano le giornate**.

### ⏭️ IL PASSO SUCCESSIVO, **PROGRAMMATO E DICHIARATO, NON FATTO**

> Due **passate singole** sulla stessa finestra — la **cella promossa** e la
> **cella viva `770411`**, entrambe con **magic vergini** (mai il 770411 vero) —
> poi i due export per-trade `abtg_trades_<EA>_D30EUR_<magic>.csv` in
> `Common\Files` (riga 2237 del `.mq5`), e il conto delle **GIORNATE in comune**.
> Se coincidono: **SCARTO PER CORRELAZIONE** (ROTTA_PROP regola 1) anche con
> numeri buoni.
>
> ⚠️ **Nota di onestà, verificata leggendo lo strumento:**
> `backtest_pipeline/sovrapposizione_sedie.py` **NON serve a questo** — legge
> `data/statements/trades_auto.csv`, cioè gli statement del **forward**, non i
> per-trade di un backtest. **Quel pezzo di codice va scritto.** È scritto così
> anche nel referto che il driver produce.

**Lo stesso vale, in forma diversa, sul Nasdaq**: il candidato Dow e il candidato
Nasdaq armano **alla stessa ora, col meccanismo identico, sulle stesse finestre
d'orologio**, su due indici correlati. **Il DD della prop è UNO.** Se passassero
tutti e due, la sovrapposizione delle giornate **viene prima** della doppia
promozione.

---

## 5. 🧪 Che cosa ho **eseguito** (non "riletto")

Qui non c'è MT5 — ma **PowerShell 7.4.6 c'è**, e i due driver sono stati **fatti
girare per intero**.

| prova | esito |
|---|---|
| `Parser::ParseFile` su tutti e due i driver | ✅ puliti |
| `backtest_pipeline/lint_ps1.py` | ✅ `2 file controllati, nessun problema` |
| `controlla_prova.py` sui 10 file prova (DAX + NAS) | ✅ **zero parametri orfani** (pin 73 / 87) — con il rilievo "3 assi Y" **che il Dow dà identico** |
| **Audit AST** su tutti e due i driver: parametri del `param()` mai usati · funzioni che collidono con un **alias** · variabili che differiscono **solo per maiuscole** | ✅ nessuno *(341 e 332 nomi di variabile, 28 e 26 funzioni)* |
| **17 test unitari** sulle due funzioni NUOVE (`MinutiNelBox`, `OraDiMin`), compresi i bordi (`pw 179 → 0`, `pw 181 → 1`, `pw 481 → −1` = finestra che scavalla, `OraDiMin -60 → 23:00`) | ✅ tutti verdi |
| **I due driver INTERI su un banco stubbato**, coi **file prova veri** | ✅ vedi sotto |
| 🔨 **19 gate FATTI SCATTARE**, uno per uno | ✅ **19 su 19** |

### 🔬 Il giro sul banco stubbato ha prodotto, sui file prova veri

Stub: `Get-Process` (nessun MT5 aperto), `Invoke-WebRequest` (il "pin" pesca dal
repo locale), `Get-ChildItem` su `C:\Program Files`, un finto `metaeditor64.exe`
che scrive l'`.ex5`, e il driver generico. **I gate, il parser dei file prova e
la costruzione dell'`.ini` del cancello girano VERI.**

- **DAX**: tutti i gate passati · assi contati `5 × 3 × 2 = 30` · `apertura
  confermata sul file prova: 08:00 server (box della sedia gemella 770411:
  23:00 - 04:59)` · cella del cancello `PrevWindowMin=180, RetestOffsetPts=400,
  magic 782000` · `.ini` della passata singola scritto e **passato per tutti i
  suoi gate** · celle attese `6/6/30/30` · **`ESITO: CONTROLLO COMPLETATO`,
  uscita 0**;
- **NAS**: idem, con `fasi ........ COSTO -> RIF -> GRIGLIA` e i lavori
  `rif_long / rif_short / griglia_long / griglia_short` · cella del cancello
  `magic 782500` · **uscita 0**;
- ✅ **la tabella della sovrapposizione col box notturno è quella stampata al §4:
  è OUTPUT DEL DRIVER, non un conto fatto a mano.**

### 🔨 I 19 gate fatti scattare — perché un gate mai fatto scattare non è dimostrato

Per ognuno si corrompe **una riga** dei file prova (in **tutti e cinque** quando
si vuole colpire il gate specifico, in **uno solo** quando si vuole colpire il
gate della stella) e si pretende **il messaggio giusto**:

| gate | esito |
|---|---|
| DAX `InpSessionHour` ≠ 8 (l'ora **italiana** al posto della server) | ✅ morde |
| DAX `InpSessionMin` ≠ 0 | ✅ morde |
| DAX `InpMinStopPts` = 500 (il valore del **Dow**) | ✅ morde |
| DAX `InpSkipIfTight` = 0 (il valore del **Dow**) | ✅ morde |
| DAX `InpAllowReverse` = 1 (due cicli al giorno) | ✅ morde |
| DAX magic = **`770101`** (la sedia viva) | ✅ morde |
| DAX magic = **`770411`** (l'altra sedia viva) | ✅ morde |
| DAX cella del cancello **fuori dal centro** della griglia | ✅ morde |
| DAX `InpRangeMode` sbagliato nel file METRO (file **scambiati**) | ✅ morde |
| DAX un parametro che differisce dal LONG **e non è un delta dichiarato** | ✅ morde (gate della stella) |
| DAX `InpPrevWindowMin` **ancora un asse** nel METRO | ✅ morde |
| NAS `InpUseVolRegime` = 1 (blocco R30 acceso) | ✅ morde |
| NAS `InpUseSRFilter` = 1 | ✅ morde |
| NAS `InpSkipIfTight` = 1 | ✅ morde |
| NAS `InpMinStopPts` = 0 (pavimento spento) | ✅ morde |
| NAS magic = **`770201`** (la sedia **spenta**) | ✅ morde |
| NAS magic = **`761200`** (bruciato da R107) | ✅ morde |
| NAS `InpSessionHour` = 15 (ora italiana) | ✅ morde |
| NAS cella del cancello fuori dal centro | ✅ morde |

### 🐛 Due cose trovate **eseguendo**, non leggendo

1. 🔧 **Il gate dell'orologio scattava PRIMA di quello specifico.** Il gate nuovo
   («l'apertura del file prova deve essere quella su cui la riga calcola la
   sovrapposizione col box notturno») stava **prima** del ciclo dei lavori:
   mettendo `InpSessionHour=9` usciva *«sono due orologi diversi»* invece del
   messaggio utile *«InpSessionHour deve essere 8 … 9 sarebbe l'ora italiana:
   cestinare»*. **Spostato dopo**: adesso vince il messaggio **azionabile**.
   _(È una variante del punto 55: il gate riparato che si mangia il messaggio
   giusto.)_
2. 🔧 **`-SoloFase` documentato con un valore che non esiste.** Nel driver NAS
   il commento del `param()` diceva `COSTO | RIFERIMENTO | GRIGLIA` mentre il
   valore valido è **`RIF`**: sarebbe stato un giro a vuoto sicuro per chi
   avesse letto il commento. Corretto.

---

## 6. ⚠️ Quello che **non** è stato verificato — dichiarato

- ❌ **Niente è stato misurato sul banco vero.** Qui non c'è MT5: i giri sopra
  servivano a far scattare i gate e a leggere gli artefatti, **non** a dire come
  vanno i motori.
- ❌ **I due EA non sono stati compilati per davvero.** Il finto MetaEditor del
  banco scrive un `.ex5` di due righe. I driver **compilano davvero** anche nel
  giro a vuoto (e cancellano l'`.ex5` prima — CHECKLIST 54): se MetaEditor si
  lamenta, il risultato è quello e va riportato così com'è.
- ❌ **Lo spread non è misurato**: è **dichiarato** 2,0 punti indice su tutti e
  tre gli indici (R109_CRITERI D4, lato alto della forchetta 1-2 di
  R98_CRITERI). Il *RealCost Spread P95 Logger* (Code Base 74148) è promosso dal
  23/08 e **ancora mai usato**.
- ❌ **Il pavimento `VOLUME_MIN`/`VOLUME_MAX`** sui **bordi larghi** della
  griglia **non è misurato**. Sul DAX pesa **più** che sul Dow, perché lì il
  pavimento SL è **spento**. I referti lo espongono come `[DA VERIFICARE]` e
  stampano min/max/valori distinti dei volumi della cella del cancello.
- ❌ **Il doppione DAX ↔ `770411` non è misurato**: la tabella è di
  **calendario**. Le giornate in comune sono il passo successivo (§4).
- ❌ **La correlazione Dow ↔ Nasdaq non è misurata**: stesso passo successivo.
- ✅ **I pin NON sono più segnaposto** (aggiornato dopo `bb62e87`): tutte e due le
  pagine portano il pin vero **`b40c62c3652286a792e5f6fbdb96cac5898480f5`** nei tre
  blocchi di lancio e il cartello del segnaposto è stato tolto. Ri-verificato il
  28/08 dal verificatore-stringhe: il pin è **antenato di `origin/lavoro`**; i
  **sedici** artefatti che i due script scaricano hanno al pin lo **stesso blob**
  che hanno a `HEAD` e nel working tree (`git rev-parse <pin>:<file>` ==
  `HEAD:<file>` == `git hash-object`); i `raw.githubusercontent.com/.../<pin>/...`
  rispondono **200** e contengono i due marcatori.
- ✅ **Le righe SONO state passate al verificatore-stringhe** (28/08): FAIL con
  5 difetti, tutti doc-only (nessuno tocca i 16 artefatti scaricati → nessun
  ri-pin necessario), corretti nello stesso passo in cui si scrive questa riga.

---

## 7. 🗂️ Due round separati e non uno solo — la scelta, motivata

Il mandato lasciava aperta l'opzione «un'unica riga con due modalità». **Ho
scelto due driver separati.** Motivi, in ordine di peso:

1. **I due round non dicono la stessa cosa.** Sul DAX c'è un **METRO** (sedia
   viva, gate G0 possibile); sul Nasdaq c'è un **RIFERIMENTO** (sedia spenta,
   **nessun G0**). Un unico referto renderebbe facilissimo leggere un numero
   Nasdaq sotto un cappello DAX.
2. **Le baseline sono diverse in cinque punti** (EMA, buffer, offset vivo,
   pavimento SL, `SkipIfTight`) e i gate che le proteggono sono **valori diversi
   nello stesso gate**. Un driver parametrico avrebbe dovuto tenere due tabelle
   di costanti: la stessa cosa, scritta peggio.
3. **CHECKLIST 26 e 96**: due chiamate nello stesso blocco che condividono un
   artefatto (l'anteprima, la cartella di lavoro, lo zip) sono la fabbrica dei
   referti stantii. Con due driver, **nessuno dei due round può contaminare
   l'altro**.

Il costo è la duplicazione del codice. È **mitigato**: i due driver sono stati
**derivati da `RIGA_PREOPEN_DOW.ps1` con uno script che ASSERISCE ogni
sostituzione** (se il progenitore cambia, lo script esplode invece di produrre un
driver a metà), e sono stati poi **eseguiti tutti e due**.

---

## 8. ⏭️ Cosa serve da Claudio, in ordine

1. **Correggere agli atti**: la sedia Nasdaq `770201` è **SPENTA**, non viva.
2. **Approvare (o negare) le interpretazioni**, che sono **quattro sul DAX** —
   le tre già viste stamattina sul Dow **più** la n. 4, cioè **il pavimento SL
   lasciato a 0 sul DAX** — e **tre sul Nasdaq** (le stesse del Dow).
3. **Decidere l'ordine.** Il mio consiglio, e il perché:
   - 🥇 **DAX per primo**: sedia viva, contratto pieno, metro forte (n OOS 270),
     **entrambi i lati misurabili**. È il round che può dire qualcosa di nuovo.
   - 🥈 **Nasdaq per secondo, o mai**: quattro bocciature indipendenti alle
     spalle. Ha valore come **porta che si chiude con un numero**, non come
     candidato. Se la macchina serve altrove, **questo è il round da rimandare**.
4. Solo dopo: **giro a vuoto**, poi **corsa vera**, con i blocchi delle pagine
   👉 `righe/RIGA_PREOPEN_DAX_DA_MANDARE.md` · `righe/RIGA_PREOPEN_NAS_DA_MANDARE.md`
