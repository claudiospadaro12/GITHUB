# 💱 LA MISURA DELLO SPREAD FOREX — serve uno strumento nuovo? **NO. E ce n'e' uno GIA' ACCESO.**

**12/09/2026.** Referto di sola lettura: **non tocca nessun EA, nessun preset,
nessun forward, nessun rischio.** Nessuna passata di tester, in nessuno dei due
percorsi proposti.

> 🚦 **NON ANCORA PASSATO DAL CANCELLO.** Dopo questo referto passa da
> `controllo-preventivo`. **Niente di qui va a Claudio prima di un PASS.**

---

# 0. 🥇 LE CINQUE RIGHE CHE RESTANO

1. 🟢 **Non serve nessuno strumento nuovo, e non serve scaricare niente da
   terzi.** Il logger del Code Base **74148 e' gia' stato riscritto in casa**
   come `ABTG_SpreadLogger.mq5` (con attribuzione, r.11-18), e la riscrittura
   e' **strettamente migliore** per questa domanda. Il sorgente di terzi l'ho
   **scaricato e letto**: non aggiunge nulla (§2).
2. 🔥 **E' GIA' ACCESO E STA GIA' MISURANDO LE TRE COPPIE CHE SERVONO.** Sul
   demo **50503392** dal **06/09 sera**, con `InpSimboli` a 8 simboli fra cui
   **EURUSD, GBPUSD, USDJPY** — esattamente le tre su cui poggia il bersaglio
   M30. Verificato vivo **oggi**. Manca **solo la raccolta**, che e' **una riga
   che esiste gia' ed e' gia' passata dal cancello** (§4).
   👉 La misura che sette cacce chiedono **e' a un comando di distanza, e il
   comando non apre e non chiude MT5.**
3. 🔴 **E INTANTO HO TROVATO UN ERRORE CHE RESTRINGE IL BERSAGLIO PRIMA DI
   MISURARE QUALUNQUE COSA.** La commissione si paga sul **nozionale in valuta
   BASE**, ma il pip si incassa nella valuta **QUOTA**: quindi **in pip la
   commissione NON e' la stessa per tutte le coppie.** Su GBPUSD vale
   **0,5425 pip**, non 0,47 (che e' il numero di EURUSD, riusato). All-in GBPUSD
   **0,7425** invece di 0,67, e il pavimento 40x chiede **29,7 pip invece di
   26,8** (§3).
   🧪 **E non dipende dalla data dei cambi**: rifatto con una tabella
   **indipendente**, lo scarto e' **0,124%** (§3.1-bis). Il ritrovamento tiene.
4. 🧪 **E il contro-esempio morde piu' di quanto la caccia temesse.** Non serve
   che lo spread esca 0,5: **alla lettura unica di 0,2 che abbiamo GIA'**, un
   M30 con stop 28 pip fa **37,7x** — **sotto il 40x**. Perche' il bersaglio a
   28 pip tenga, lo spread deve uscire **<= 0,158 pip**, cioe' **piu' basso
   della lettura ottimista da cui siamo partiti** (§3.2).
5. 🎯 **E LA COPPIA GIUSTA FORSE NON E' GBPUSD: POTREBBE ESSERE AUDUSD** — che
   e' una delle quattro **[NON MISURATE]**. Quando la commissione e' il
   **73,1%** del pedaggio, quello che conta non e' lo spread piu' stretto ma la
   **valuta base piu' economica**: AUDUSD paga **0,2845 pip** di commissione
   contro i **0,5425** di GBPUSD, **0,258 pip di vantaggio strutturale**.
   **AUDUSD batte GBPUSD se il suo spread esce sotto 0,458 pip** (§3.3).
   🔥 **QUESTO E' IL RITROVAMENTO, e le correzioni del cancello non lo
   intaccano**: nessuno di questi numeri passa dal JPY, e tutti sono
   date-robusti. 👉 **Le quattro coppie cieche passano da "completezza" a
   DECISIVE.**

---

# 1. 🔎 LA PRIMA DOMANDA: `ABTG_SpreadOrario` PUO' FARE IL FOREX?

**Risposta: SI', e senza toccare una riga di codice.** La domanda del brief era
se la conversione in "punti indice" fosse **hardcoded sugli indici**. **Non lo
e'.** Sorgente `mql5/Scripts/ABTG_SpreadOrario.mq5`:

| riga | codice | cosa vuol dire |
|---|---|---|
| **57** | `input double InpPuntiPerIndice = 100.0;` | e' un **`input`**, non una costante: si passa da fuori |
| **124** | `double point = SymbolInfoDouble(sym, SYMBOL_POINT);` | il `point` si legge **dal simbolo**, simbolo per simbolo, dentro il ciclo |
| **198** | `double sprRaw = (tk[i].ask - tk[i].bid) / point;` | lo spread grezzo usa **quel** `point` |
| **199** | `long sprPts = (long)MathRound(sprRaw);` | l'istogramma e' in **PUNTI MT5** |
| **263-266** | `.../InpPuntiPerIndice` | la conversione e' **solo la stampa finale** |

👉 Il dato grezzo e' sempre in punti MT5 e si adatta da solo. Per il forex
basta lanciare con **`-PuntiPerIndice 10.0`** e i numeri escono in **pip**.

E il `10.0` **non e' una scelta mia**: e' la conversione che vale per **tutte e
sette** le coppie del bersaglio, perche' i `Digits` sono misurati. Fonte
**gia' sul disco** (`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`,
sezione SIMBOLI):

| coppia | `Digits` | `Point` | 1 pip = |
|---|---:|---|---:|
| EURUSD · GBPUSD · AUDUSD · EURAUD | **5** | `0.00001` | **10 punti MT5** |
| USDJPY · CHFJPY · GBPJPY | **3** | `0.00100` | **10 punti MT5** |

🟢 **Le due famiglie danno lo STESSO fattore 10.** Una corsa forex-only con
`-PuntiPerIndice 10.0` e' corretta per tutte e sette.

### 🔴 MA C'E' UNA TRAPPOLA, e va scritta perche' e' silenziosa
`InpPuntiPerIndice` e' **UNO SOLO PER CORSA**, mentre `point` e' per simbolo.
Quindi **mescolare forex e indici nella stessa corsa produce numeri sbagliati
di un fattore 10 senza nessun errore a schermo**: gli indici vogliono 100, il
forex 10. 👉 **La corsa forex va fatta con SOLI simboli forex.** Non e' un
difetto del motore, e' un vincolo d'uso — e il referto che ne esce va letto
controllando la riga `conversione :` (r.317), che lo stampa.

> ⚠️ **`ABTG_SpreadLogger` non ha questa trappola**: la conversione la decide
> **per simbolo** dai `Digits` (`PuntiPerUnita()`, r.191-197), con autotest
> dedicati (r.344-345: *"ppu 5 decimali = 10 (pip)"*, *"ppu 3 decimali = 10
> (pip JPY)"*). Per un lavoro misto e' lo strumento piu' sicuro dei due.

### 2️⃣ Esiste gia' un CSV di spread forex in archivio?
**NO, e l'ho verificato.** `risultati_archivio/spread_flotta/` contiene **tre
file e sono tutti indici**: `spread_orario_{U30USD,D30EUR,NASUSD}.csv`. La
misura del 03/09 lo dichiara da sola (*"per i tre indici"*). Il solo dato forex
esistente e' la colonna `SpreadPt` della sonda del **17/08 17:34** — **una
lettura istantanea**, che e' esattamente il problema: `EURUSD=4`, `GBPUSD=2`,
`USDJPY=3` punti MT5 (= 0,4 · 0,2 · 0,3 pip) e **`0` su AUDUSD, EURAUD, GBPJPY,
CHFJPY** — dove `0` significa **nessun tick al momento della sonda**, non
spread nullo.

---

# 2. 📚 CHE COSA AGGIUNGE IL LOGGER DI TERZI? **NIENTE.** (letto, non supposto)

Scaricato da `https://www.mql5.com/en/code/download/74148` (HTTP 200, 144.007
byte, zip con il `.mq5` vero senza login) e archiviato per la regola di casa:
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/RealCostSpreadP95Logger_SongBoZhong-NOLICENSE_mql5code74148_2026-09-12.mq5`
(540 righe). **`NOLICENSE`**: l'unico appiglio e' `#property copyright "RealCost"`
alla r.9, `#property link` **vuoto**, e **zero** testo di licenza nel file.
**Letto per capire, nessuna riga copiata.**

| la domanda | il verdetto, dal sorgente |
|---|---|
| **La commissione la calcola lui?** (il nome dice *RealCost*) | 🔴 **NO.** `grep` su `commission\|notional\|cost`: **zero** occorrenze di codice — solo il nome del prodotto e il prefisso file. **"RealCost" e' un marchio, non una funzione.** Il pezzo che a noi serve davvero (§3) **non c'e'** |
| **Fa le fasce orarie?** | 🔴 **NO.** `TimeToStruct` compare **una volta sola**, r.512, dentro `DateForFile()` — serve a **comporre il nome del file**. Nessun istogramma per ora |
| **Multi-simbolo?** | 🔴 **NO.** `_Symbol` (simbolo del grafico) in r.104/180/197/201/204/333/381/453. Sette coppie = **sette grafici** |
| **Tiene tutti i campioni?** | 🔴 **NO.** `InpMaxSamples = 20000` (r.25): oltre, **dimentica i piu' vecchi in silenzio** |
| **E' innocuo su un terminale che opera?** | 🟡 `InpPopupAlerts = true` e `InpPushNotifications` (r.28-29): **allarmi e push**. Sul VPS e' rumore che non vogliamo |

### ✅ LA DECISIONE, MOTIVATA
**Si usa `ABTG_SpreadLogger` (nostro).** Non per campanilismo: il file di terzi
**non sa fare** le tre cose che decidono (fasce orarie, multi-simbolo,
memoria che non dimentica) e **non sa fare** la commissione che il suo nome
promette. La nostra riscrittura ha in piu' anche la **ripresa dello stato dopo
un riavvio** (r.40-44) — senza la quale un riavvio del VPS azzererebbe la
raccolta *sembrando sana* (classe 106).
🟢 **Niente e' stato buttato**: l'attribuzione al 74148 e' nel sorgente di casa
dal primo giorno, e ora anche il sorgente originale e' in biblioteca.

---

# 3. 🧮 IL CONTO CHE SERVE DAVVERO — e dove la caccia di oggi si e' sbagliata

Il numero utile non e' lo spread: e' **`stop_tipico / costo_all_in`** contro il
pavimento **40x** (di lavoro) e **13,3x** (duro). Il costo all-in ha **due
gambe**, e hanno **solidita' opposta**:

| gamba | stato | fonte |
|---|---|---|
| **commissione** | 🟢 **MISURATA** sulle operazioni vere: `-4,0000 EUR` **esatti**, n=84, **varianza ZERO** | `CANCELLO_COSTO_FLOTTA_2026-09-10.md` |
| **spread** | 🔴 **[LETTURA UNICA]** del 17/08, o **[NON MISURATO]** su 4 coppie | sonda istantanea |

## 3.1 🔴 LA COMMISSIONE IN PIP NON E' UNA COSTANTE — ed e' stata usata come tale

La legge e' `0,004% del nozionale in valuta BASE, giro completo` = **4,0 unita'
di valuta base** per lotto. Ma **il pip si incassa nella valuta QUOTA**. Quindi
la commissione **in pip** dipende da **quanto vale la valuta base**:

```
comm_pip = 4,0 x (base/quota) / (100.000 x pip_size)
```

Strumento, ASCII puro, **zero passate di tester**:
`backtest_pipeline/calcola_pedaggio_forex.py`.

### 🔴 E QUI IL CANCELLO MI HA CORRETTO DUE VOLTE — le correzioni, per intero

**a) La v1 dichiarava "due ancore su tre". LA GENUINA ERA UNA.**
La v1 ricavava `JPY/EUR = (USD/EUR) / 150,0` con il **150,0 ASSUNTO**. Ma su
USDJPY **la base E' USD**, quindi `USD/EUR` **si cancella algebricamente** e
restava:

```
comm_USDJPY = 4,0 x 150 / 1.000 = 0,600   <-- PER COSTRUZIONE
```

🔴 **Non era una conferma: era un'identita'.** Potere di falsificazione
**ZERO** — quel numero sarebbe uscito 0,600 qualunque cosa facesse il mercato.
🟢 Va detto in difesa dello *strumento*: il sorgente **dichiarava l'assunto**.
E' il **referto** che l'ha promosso ad ancora, e quello e' un mio errore di
lettura, non un difetto del codice.

**b) Il cambio vero era nel file che avevo GIA' APERTO.** La regola del 10/09
(*"prima si cerca il file che ha gia' la risposta"*) si ripaga con
un'aggravante: della sonda `215D85D7_ABTG_InfoBroker.csv` avevo letto **due
colonne su quattordici** (`Digits`, `Point`). Il conto e' in **EUR** (sezione
SERVER, r.7 `Valuta,EUR`), quindi:

```
quota/EUR = TickValue / (ContractSize x TickSize)
```

⇒ **`USD/JPY = 0,86287 / 0,0054147 = 159,36`, non 150,0.**

### 🟢 E LA TABELLA CHE NE ESCE E' MOLTO PIU' FORTE DI QUELLA CHE AVEVO
Una **sola istantanea** (17/08 17:34 srv) che copre **tutte** le valute che
servono, e **controprovata dentro se stessa**: la stessa valuta quota, letta da
coppie **diverse**, torna. Scarto relativo massimo **0,012%**.

| valuta | X/EUR | letto da | controprova |
|---|---:|---|---|
| **USD** | 0,86287 | EURUSD · GBPUSD · AUDUSD · NZDUSD | 🟢 **4 coppie** |
| **JPY** | 0,0054147 | USDJPY · CHFJPY · GBPJPY · EURJPY | 🟢 **4 coppie** |
| **CAD** | 0,62216 | EURCAD · USDCAD · GBPCAD | 🟢 3 coppie |
| **CHF** | 1,06559 | USDCHF (EURCHF: 1,06550) | 🟢 2 coppie |
| **NZD** | 0,50988 | EURNZD · AUDNZD | 🟢 2 coppie |
| **GBP** | 1,17026 | EURGBP | 🟡 1 coppia |
| **AUD** | 0,61372 | EURAUD | 🟡 1 coppia |

### Il conteggio ONESTO delle ancore, rifatto
| coppia | derivato | scritto da altri | esito |
|---|---:|---:|---|
| **EURUSD** | **0,4636** pip | `~0,5` (10/09) · `0,47` (CACCIA_SABATO 2.3) | 🟢 **riproduce — l'UNICA ancora genuina** |
| **USDJPY** | **0,6374** pip | `~0,60` (CACCIA_SABATO 2.3) | 🔴 **NON riproduce** — e ora si sa perche': quel numero poggiava su un USDJPY **assunto a 150** |
| **GBPUSD** | **0,5425** pip | `~0,47` *(= il numero di EURUSD)* | 🔴 **NON riproduce** |

👉 **Una ancora genuina, e DUE numeri della caccia da correggere** (non uno).
Il `~0,47` di GBPUSD e' il valore di EURUSD riusato; il `~0,60` di USDJPY
poggiava su un cambio assunto che **il disco smentisce**.

## 3.1-bis 🧪 LA PROVA CHE IL RITROVAMENTO NON E' FRAGILE

Se il verdetto dipendesse da **quale data** dei cambi uso, sarebbe fragile.
Rifatto con la tabella **indipendente** del 10/09 (i cambi impliciti nelle
commissioni **misurate**): **non dipende**, perche' la commissione e' un
**RAPPORTO** fra due valute e la deriva comune **si cancella**.

| coppia | cambi 17/08 | cambi 10/09 | scarto |
|---|---:|---:|---:|
| **GBPUSD** | **0,5425** | **0,5432** | 🟢 **0,124%** |
| AUDUSD | 0,2845 | 0,2848 | 🟢 0,121% |
| EURUSD | 0,4636 | 0,4677 | 🟢 0,897% |

🟡 **Le due date vanno dichiarate, ed erano mescolate nella v1**: su `USD/EUR`
differiscono dello **0,9%** (0,86287 contro 0,8552) — e' deriva di cambio fra
17/08 e 10/09, non un errore. **La tabella primaria e' ora una sola data.**

### La classifica del pedaggio, ristampata coi cambi del disco
| coppia | valuta base | **commissione (pip)** |
|---|---|---:|
| **AUDUSD** | AUD | 🥇 **0,2845** |
| EURUSD | EUR | 0,4636 |
| **GBPUSD** | GBP | **0,5425** |
| EURAUD | EUR | 0,6518 |
| USDJPY | USD | 0,6374 |
| EURJPY | EUR | 0,7387 |
| GBPCAD | GBP | 0,7524 |
| **CHFJPY** | CHF | **0,7872** 🟢 *era dichiarata `[NON CALCOLABILE]`: vedi sotto* |
| GBPJPY | GBP | 0,8645 |

> 🔴 **E UNA MIA AFFERMAZIONE ERA FALSA.** La v1 scriveva *"il cambio del CHF
> non e' fra gli otto misurati"* e dichiarava **CHFJPY `[NON CALCOLABILE]`**.
> **Vero per il 10/09, falso per il disco**: il CHF e' sul disco dal **17/08**
> (`USDCHF` -> `CHF/EUR = 1,06559`, controprovato da `EURCHF` -> 1,06550).
> **CHFJPY paga 0,7872 pip** ed e' la **seconda piu' cara** del gruppo.
> 🟢 Il meccanismo del rifiuto, pero', **funziona**: provato con il JPY
> **togliendolo** dalla tabella, lo strumento torna `n/d` invece di stimare.
> Era giusto il codice, sbagliata la tabella che gli davo.

## 3.2 🧪 IL CONTRO-ESEMPIO — e smentisce il bersaglio **piu' presto** del previsto

La caccia diceva: *"se GBPUSD fosse 0,5 invece di 0,2, la soglia passa da 26,8 a
38,8 pip e il bersaglio M30 sparisce"*. **Con la commissione corretta il
bersaglio sparisce gia' allo spread che abbiamo gia' letto:**

| spread misurato | all-in | stop 28 pip fa | esito del bersaglio |
|---:|---:|---:|---|
| 0,1 | 0,642 | **43,6x** | 🟢 TIENE |
| **0,2** *(la lettura unica di oggi)* | **0,742** | **37,7x** | 🔴 **SPARITO** |
| 0,3 | 0,842 | 33,2x | 🔴 SPARITO |
| 0,5 *(l'ipotesi della caccia)* | 1,042 | 26,9x | 🔴 SPARITO |
| 1,0 | 1,542 | 18,2x | 🔴 SPARITO |

🔴 **La soglia che decide: lo spread GBPUSD deve uscire `<= 0,158 pip`** perche'
un M30 con stop 28 pip tenga il 40x. **Nessuno spread sotto 1,56 pip sfonda il
pavimento DURO**, quindi non e' una bocciatura: e' il **40x di lavoro** che
diventa irraggiungibile a quello stop.

👉 **E la misura PUO' produrre quel numero**: il logger tiene l'istogramma in
**punti MT5** (r.804), cioe' **0,1 pip di risoluzione** su una coppia a 5
decimali. Distinguere 0,2 da 0,5 pip = distinguere 2 punti da 5. **La misura
decide davvero**, in tutte e due le direzioni.

## 3.3 🎯 LA CONSEGUENZA STRATEGICA: forse la coppia giusta e' AUDUSD

Sul GBPUSD la commissione e' il **73,1%** del pedaggio (0,5425 su 0,7425).
Quando una voce pesa il 73%, **ottimizzare l'altra e' rumore**. La caccia ha scelto
GBPUSD perche' aveva lo **spread** piu' stretto; ma la variabile che domina e'
la **valuta base**.

> **AUDUSD parte con 0,258 pip di vantaggio strutturale** e batte GBPUSD se il
> suo spread misurato esce **sotto 0,458 pip** — un valore largo, che la
> maggioranza dei major rispetta.
> 🟡 **E quel `0,458` poggia su uno spread GBPUSD di 0,2 pip, che e' una
> `[LETTURA UNICA]`** (sonda istantanea del 17/08 17:34, **non** una
> distribuzione). Se il GBPUSD vero e' piu' largo, **la soglia si alza e AUDUSD
> vince ancora piu' facilmente**: la direzione dell'incertezza, qui, e'
> **favorevole** al ritrovamento.
> 🔴 **E AUDUSD e' una delle quattro coppie dove la sonda legge `0`.**

👉 Quindi la misura non serve solo a **confermare o smentire** GBPUSD M30:
serve a capire **se stiamo cercando sulla coppia sbagliata**. Questo alza la
priorita' delle quattro coppie "cieche" da *completezza* a **decisiva**.

## 3.4 🔴 E GLI STOP M30 FOREX RESTANO `[NON MISURATO]` — non li estrapolo

Cercati in archivio. Gli stop forex **misurati** (`trades_auto.csv`, via
`CANCELLO_COSTO_FLOTTA` §5.4) esistono **solo su H1 e H4**: 35,0 · 47,0 · 29,2 ·
38,9 · 22,1 · 35,6 · 58,6 pip, con **n da 1 a 3**. **Nessuna sedia forex gira su
M30**, quindi **nessuno stop M30 forex esiste in casa.**
🚫 **Non lo estrapolo dall'H1 dividendo per due**: il 28 pip usato in §3.2 e'
**l'ipotesi della caccia** (*"un M30 con stop 27-30 pip"*), etichettata come
tale, **non una mia misura**. Per questo `calcola_pedaggio_forex.py` **rifiuta
di stampare un rapporto** senza `--stop` esplicito e scrive *"STOP NON
MISURATO"*. **Chiudere questo buco richiede una passata di tester e non e' in
questo referto.**

---

# 4. 🚀 LE DUE STRADE — e nessuna delle due costa una passata di tester

## 🥇 STRADA A — la raccolta di cio' che e' GIA' in corso (EURUSD · GBPUSD · USDJPY)

🖥️ **BERSAGLIO: finestra PowerShell sul VPS `VMI3047753`.**
🪟 **Legge la cartella dati del solo terminale PICCOLO `50503392`**
(`C:\Program Files\BCM Markets MT5 Terminal`, **senza** `-V3`).
✋ **Nessun MT5 da aprire e NESSUNO da chiudere.**
🔴 **COSA NON VIENE TOCCATO:** il **REALE 10105439** (`C:\BCM_Reale`, **acceso
con sedie vive**), il **100k 50504263** (`-V3`, in Fase 1), il banco
**50504400**, e le cartelle **Pepperstone** e **Tickmill**. Delle **sei**
cartelle dati del VPS questa riga ne legge **una**.

**Perche' e' sicura, dal sorgente** (`RIGA_SPREADLOGGER_RACCOLTA.ps1`, r.10-17):
> *"NON TOCCA NIENTE. [...] Nessuna scrittura dentro MetaQuotes\Terminal,
> nessuna compilazione, **nessun processo fermato**: MT5 puo' (e deve) restare
> APERTO e la flotta continua a lavorare."*

🟢 **Non c'e' nessun `Stop-Process` in quello script.** L'incidente del 10/09
(una chiusura "pulita" che ammazzo' anche il reale) **non puo' ripetersi qui**,
perche' qui **non si chiude niente**.

🟢 **La riga esiste gia'**: BLOCCO 3 di
`backtest_pipeline/righe/RIGA_SPREADLOGGER_DA_MANDARE.md` — con `irm` + pin +
marcatore + **raccolta** (cartella Desktop + `Compress-Archive` + elenco dei
file attesi). **Non l'ho riscritta**: riscriverla sarebbe inventare rischio
dove non ce n'e'.

### 🔴 MA IL MIO «GIA' PASSATA DAL CANCELLO» NON ERA RIPRODUCIBILE COM'ERA SCRITTO
Detto cosi', chi rifa' il controllo **trova FAIL e si ferma**. Il cancello
dipende da **come si dichiarano gli oggetti**, e va scritta l'invocazione
esatta. Misurato in quattro modi, e **riprodotto da me**:

| invocazione | esito |
|---|---|
| `--riga <BLOCCO 3 estratto> --ps1 ...RACCOLTA.ps1` | 🟢 **uscita 0**, *"nessun difetto meccanico"* ⬅️ **questa e' quella giusta** |
| `--ps1 ...RACCOLTA.ps1` da solo | 🟢 uscita 0 |
| `--riga <il .md intero> --ps1 ...RACCOLTA.ps1` | 🔴 **uscita 1, 9 bloccanti** |
| idem con **entrambi** gli `--ps1` | 🔴 uscita 1, 9 bloccanti |

🟢 **I 9 bloccanti sono TUTTI falsi positivi del passare il `.md` come riga di
lancio**, e li ho contati uno per uno: **1** `[ASCII]` (emoji in un `.md`, che
la regola di casa **vuole**), **4** `[187]` (incroci marcatore x script su un
documento che ne contiene **due** — gli accoppiamenti giusti passano tutti e
due), **3** `[TERMINALE]` + **1** `[CONTO]` su **prosa italiana che nomina il
100k per RIFIUTARLO**. 👉 **Il documento non e' una riga di lancio: la riga e'
il BLOCCO 3 dentro il documento**, e va estratta prima di passarla al cancello.

### 🔴 E LA RIGA E' STATA RI-PINNATA OGGI, perche' ho indurito lo script
`VistoPiccolo` era **misurato** (r.222) e **mai usato come cancello**:
l'eleggibilita' era `MQL5 + bases BCM + non-V3`, quindi il **REALE 10105439** e
il **banco 50504400** — anch'essi BCM e **senza** `-V3` — **passavano il
gate**. Non e' mai diventato un incidente per **tre fortune** (la riga non
scrive sul terminale, la discriminante finale e' il **file di stato del
logger**, e sull'ambiguita' **si ferma** con un `throw`). 🔴 **Tre fortune non
sono un metodo**, quindi il buco e' chiuso:
- reale e banco ora **rifiutati** con lo stesso schema a **tre tracce**
  indipendenti del 100k (`origin.txt`, percorso, login nei log);
- `VistoPiccolo` promosso a criterio di selezione **dove restringe**;
- 🟢 **fallisce in SICUREZZA**: se `origin.txt` manca e i log non nominano
  nessuno, **non cambia niente** rispetto a prima.

**Provato**: `Parser::ParseFile` **0 errori** (5.924 token) e **6 casi su 6
verdi** (reale con e senza `\` finale, minuscolo, banco, **il piccolo che DEVE
passare**, `origin.txt` vuoto).

🔴 **Conseguenza da non perdere:** marcatore -> **`..._RACCOLTA_v2`** e pin del
BLOCCO 3 -> **`e86deb5a367ca19da918c5a16248d35b4307143a`**. **I BLOCCHI 1-2
restano al pin vecchio** (l'EA non e' stato toccato): **la pagina ha due pin,
apposta**, e §2 lo dice. 🚦 **Il pin nuovo non e' ancora verificato via `raw`**
(il commit e' di oggi): va fatto prima dell'invio.

### ⏳ E I GIORNI CI SONO — oggi e' il giorno giusto
`HANDOFF.md` §06/09: *"lanciare `RIGA_SPREADLOGGER_RACCOLTA.ps1` dopo **5
giornate** di borsa per la prima lettura, **10** per il referto buono"*.
Accesa il **06/09 sera** -> lun 07, mar 08, mer 09, gio 10, ven 11 = **5 sedute
chiuse**. 🟢 **La prima lettura e' matura oggi.** Il referto marca da solo le
righe sottili (`-MinGiorni 5`, r.48).
🟡 Per il referto "buono" (10 sedute, due rollover) si rilancia **la stessa
riga** verso il **19/09**: e' rilanciabile quante volte si vuole.

## 🥈 STRADA B — le quattro coppie cieche (AUDUSD · EURAUD · GBPJPY · CHFJPY)

Due modi, e **il primo e' meglio se i tick ci sono**:

### B1 — tick storici sul banco (istantaneo, se i tick ci sono)
🖥️ **BERSAGLIO: finestra PowerShell sul PC/macchina che ospita il banco.**
🪟 **Terminale `50504400` (`C:\MT5_Backtest`), che e' SPENTO.**
🔴 **Questa riga APRE e CHIUDE MT5**, quindi il bersaglio **deve** essere il
banco. 🟢 **Ed e' gia' stata resa chirurgica oggi stesso**: il blocco
`RIPIEGO_BANCO_v1` (12/09, `RIGA_SPREAD_FLOTTA.ps1` r.257-274) punta **solo** a
`C:\MT5_Backtest` e **si rifiuta di ripiegare** su Program Files (*"li' c'e' il
piccolo 50503392, che ha le sedie VIVE"*); la chiusura finale (r.564) e'
filtrata su `$_.Path -like ($instDir + "\*")`, **non** su tutti i `terminal64`.

🟢 **Nessuno script nuovo**: `RIGA_SPREAD_FLOTTA.ps1` prende **gia'** i
parametri che servono (r.86-90: `-Simboli`, `-Da`, `-A`, `-PuntiPerIndice`).
La corsa forex e' **una riga di parametri**, con `-PuntiPerIndice 10.0` e
**solo simboli forex** (§1, la trappola):

```
-Simboli "GBPUSD,EURUSD,USDJPY,AUDUSD,EURAUD,GBPJPY,CHFJPY" -PuntiPerIndice 10.0
```

🔴 **IL PRESUPPOSTO RESTA `[NON MISURATO]`, E IN TUTTI E DUE I SENSI.** Che i
**tick reali forex siano sul disco del banco** non lo so. Gli indici li avevano
(2024.09.26 -> 2026.06.30, 252 milioni di tick). Per il forex la sonda del
17/08 dice `da scaricare (parziale)` — ma **quella colonna sta in coda alle
colonne delle BARRE** (`BarreTF`/`BarreD1`, H1 e D1): 🔴 **nessuna colonna della
sonda riguarda i tick**, quindi la sonda **non dice niente sui tick — ne' che
ci sono, ne' che mancano**. Il mio *"potrebbero esserci"* basato su
`InpScaricaTick = true` (`ABTG_HistoryDownloader.mq5` r.23) e' un
**ragionamento**, non una misura, e **non vale come presupposto**.
👉 **Si chiude con una MISURA, e va fatta prima della Strada B1.** Se i tick
mancano, `MisuraSimbolo` scrive un **CSV vuoto** — che il motore tratta bene
(*"un CSV vuoto e' un fatto, non un errore taciuto"*, r.104-105), ma la corsa
**non produce la misura**.
🟡 *Di contorno, e utile saperlo:* `BarreTF` vale **100.000 / 100.008** su
EURUSD/GBPUSD/USDJPY — cioe' **il tetto delle ~100.000 barre del tester, gia'
saturo**. Non riguarda i tick, ma riguarda ogni corsa futura su quelle coppie.
⚠️ E se i tick partono dal 2024.09.26, la finestra e' **~21 mesi**: buona per
la mediana, ma e' **un solo regime**, e va dichiarato.

### B2 — allungare il logger vivo (sicuro, ma costa 5 sedute)
✋ **Azione a mano dentro MT5, terminale `50503392`** (`BCM Markets MT5
Terminal`, **senza** `-V3`): aggiungere `,AUDUSD,EURAUD,GBPJPY,CHFJPY` a
`InpSimboli` e riattaccare.
🟡 **Due costi veri, non nascosti:** (1) si aspettano **altre 5 sedute**;
(2) riattaccare e' **il passo che il 06/09 ha prodotto l'unico incidente** della
serata (**due istanze** dello stesso EA sugli stessi file di stato). Se si fa,
serve la stringa che stampa **PID + titolo + cartella** e la verifica che ci sia
**una sola** istanza.
🟢 Margine di memoria: **12 simboli** sono il tetto dichiarato (`MAXSYM`, r.130);
8 + 4 = **12**. **Ci stanno esatti, zero margine** — una coppia in piu' non ci
starebbe.

> 💡 **La mia raccomandazione (decide Claudio):** **A subito** (zero rischio,
> dati gia' maturi, chiude le tre coppie del bersaglio), **B1 in parallelo dopo
> aver accertato i tick** (istantaneo e chiude AUDUSD, che §3.3 rende
> decisiva). **B2 solo se B1 scopre che i tick forex non ci sono.**

---

# 5. ⛔ COSA QUESTA MISURA **NON** DIRA'

Va ripetuto ogni volta che si cita un suo numero.

| non copre | perche' |
|---|---|
| **slippage, requote, rifiuti** | il logger guarda `bid/ask` **quotati**, non prezzi **eseguiti**. Lo slippage e' un altro asse (`ABTG_SlippageLogger`) |
| **swap / rollover** | 🔴 **[NON MISURABILE]** da qui |
| **l'esecuzione della PROP vera** | e' il feed **BCM**. Un broker prop puo' avere spread e regole diverse |
| **lo spread al MINUTO** | il grano e' l'**ORA**. Su un'apertura di sessione la direzione dell'errore e' **nota e sfavorevole** |
| **gli stop M30 forex** | 🔴 **[NON MISURATO]**, §3.4. Senza, il rapporto `stop/all-in` su M30 **non si chiude** |
| ~~il cambio del CHF~~ | 🟢 **BUCO CHIUSO**: il CHF e' sul disco dal 17/08 (`USDCHF`/`EURCHF`). **CHFJPY = 0,7872 pip.** La v1 lo dichiarava `[NON CALCOLABILE]`: era falso |
| **i cambi sono di UNA data** | 17/08 17:34. Fra 17/08 e 10/09 `USD/EUR` deriva dello **0,9%**. Sui **rapporti** si cancella (§3.1-bis), ma un uso futuro a valuta singola va ri-ancorato |

---

# 6. 📦 COSA HO CONSEGNATO

| file | che cos'e' |
|---|---|
| `report/MISURA_SPREAD_FOREX_2026-09-12.md` | questo referto |
| `backtest_pipeline/calcola_pedaggio_forex.py` | il pedaggio all-in per coppia, ASCII puro, **autotest contro numeri di altre sessioni**, contro-esempio incorporato. **Zero passate di tester** |
| `.../biblioteca/sorgenti/RealCostSpreadP95Logger_SongBoZhong-NOLICENSE_mql5code74148_2026-09-12.mq5` | il sorgente di terzi, **letto e scartato con motivo** (§2) |

**Nessuno script nuovo verso il VPS**, perche' non serviva: la riga della
Strada A **esiste ed e' gia' verificata**, e la Strada B e' **parametri** di uno
script gia' indurito oggi.

```
python3 backtest_pipeline/calcola_pedaggio_forex.py --autotest
python3 backtest_pipeline/calcola_pedaggio_forex.py \
    --csv ABTG_SpreadLogger_orario.csv --ore 7,8,9,13,14 \
    --contro-esempio GBPUSD=28
```

⏳ **E quando lo zip torna, il verdetto si da' contro le soglie di §3.2, che
sono congelate QUI, prima dei numeri.**
