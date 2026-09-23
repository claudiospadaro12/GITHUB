# 🔬 LE TRE SONDE A COSTO ZERO — e **una era già fatta**

_23/09/2026 · cercatore di parametri · perimetro `/home/user/GITHUB`, branch `lavoro` · **sola
lettura**: nessun round lanciato, nessuna riga di lancio scritta, nessun terminale toccato._

> **Regola applicata prima di tutto**: _«cerca prima di proporre di misurare»_. Stanotte è
> successo due volte che un numero dichiarato mancante fosse in repo. 👉 **Oggi è successo di
> nuovo: la sonda n.3 non va fatta, il numero c'è dal 09/09.**

---

## 🎯 IL RISULTATO IN UNA RIGA

| # | numero dichiarato `[NON MISURATO]` | esito di oggi |
|---|---|---|
| **1** | spread BCM di `F40EUR` · `E50EUR` · `100GBP` | 🟠 **davvero mancante** — spec sotto, **più un prerequisito che nessuno aveva nominato** |
| **2** | ATR(10) mediano per TF su `D30EUR` | 🟢 **per l'80% è già in repo** — manca solo un rapporto, non una sonda |
| **3** | `Max barre nel grafico` sul banco `50504400` | 🟢 **CHIUSO: `MaxBars=10000000`, misurato il 09/09/2026.** Nessuna sonda da fare |

---

## 1️⃣ LO SPREAD DI `F40EUR` · `E50EUR` · `100GBP` — 🟠 davvero mancante

### Che cosa manca, contato
- `backtest_pipeline/risultati_archivio/spread_flotta/` → **3 CSV**: `D30EUR`, `NASUSD`,
  `U30USD` (corsa del **03/09/2026**, tick storici, finestra `2024.09.26 → 2026.06.30`).
- `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` → **8 simboli**: `225JPY`, `D30EUR`,
  `EURUSD`, `GBPUSD`, `NASUSD`, `U30USD`, `USDJPY`, `XAUUSD`.
- 👉 **Unione delle due fonti: 8 simboli.** `F40EUR`, `E50EUR`, `100GBP` **non ci sono in
  nessuna delle due**, e lo conferma per nome `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`
  r.342 (`[NON CALCOLABILE]`: `SPXUSD`, `F40EUR`, `E35EUR`, `E50EUR`, `100GBP`, `200AUD`).

### Lo strumento — **esiste, è promosso, ed è già pilotato**
| pezzo | dov'è | cosa fa |
|---|---|---|
| motore | `mql5/Scripts/ABTG_SpreadOrario.mq5` | **Script**, non EA e **non tester**: legge i **tick già sul disco** con `CopyTicksRange`, multi-simbolo (`InpSimboli`), istogramma **per ora server**, stampa **media / MEDIANA / P95 / max** e la **riga BID/ASK** che decide se le corse a `Spread=0` erano ottimiste |
| pilota | `backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1` | accetta già `-Simboli`, `-PuntiPerIndice`, `-Da`, `-A`, `-TimeoutMin`, `-SoloControllo`. **Nessuno script nuovo da scrivere** |
| precedente | `backtest_pipeline/righe/RIGA_SPREAD_FLOTTA_TRANCHE_DA_MANDARE.md` | le **5 tranche** già scritte per `225JPY` + oro + 10 forex. **Nessuna tranche copre i tre indici europei**: questa sarebbe la **T6** |
| prodotto | `MQL5\Files\spread_orario_<SIM>.csv` (24 righe orarie + `TUTTO`) e `REFERTO_SPREAD_FLOTTA.txt` (scritto e flushato **simbolo per simbolo**: leggibile a metà corsa) | |

`ABTG_SpreadLogger.mq5` (`mql5/Experts/`) è **l'altro** strumento e **non serve qui**: è il
logger **dal vivo**, campiona il feed in tempo reale su un terminale acceso e ha prodotto i file
`data/spread_vivo/` del 12/09. Per i tre indici europei **vogliamo la storia**, non 5 giorni.

### 🔴 DOVE GIRA — e qui c'è il **rilievo che nessun documento aveva collegato**
`RIGA_SPREAD_FLOTTA.ps1` **r.265** ha il bersaglio **cablato**:

```
$BANCO_PERC = "C:\MT5_Backtest"
```

e se non lo trova **muore** (deliberatamente: il ripiego su `Program Files` era il difetto del
12/09). Ma `C:\MT5_Backtest` è il banco **`50504400`**, e **sta sul VPS** — verificato in
`report/EMA200_DOW_COSA_MANCA_2026-09-12.md` r.287, che cita
`CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` r.8-11 e r.54-56.

> 🔴 **Quindi, così com'è, questa riga NON è lanciabile**: la firma di Claudio del **21/09**
> dice che il banco `50504400` **resta spento** mentre la challenge opera, e sul VPS si fa
> **solo lettura**.
> 🟢 **Ma non è un vicolo cieco, ed è la parte buona**: questo strumento **non usa il tester**
> (niente `metatester64`, niente ottimizzazione). È uno **Script** che legge tick da disco. Il
> costo macchina è RAM + un core, non le 8 CPU che il 21/09 hanno inchiodato il VPS. 👉 Le due
> strade possibili, **e sono una decisione, non una misura**:
> - **(A)** portare la corsa sul **PC di backtest** (`C:\Program Files\BCM Markets MT5
>   Terminal`, demo **50503392**) → serve **un parametro `-TerminaleBacktest` che oggi lo
>   script NON ha**: è una **modifica a uno script**, e passa dal cancello;
> - **(B)** accendere il banco `50504400` sul VPS per la sola durata della corsa → **è una
>   deroga alla firma del 21/09 e la firma non è mia**.

### ⚠️ IL PREREQUISITO CHE NESSUNO AVEVA NOMINATO — **e vale per tutte e due le strade**
Lo Script legge **i tick che ci sono**. Per i tre indici europei **non sappiamo se ci sono**:

1. **Profondità dei tick reali = `[NON MISURATO]`.** `risultati_archivio/misura_tick/` ha **3
   referti**: `D30EUR`, `NASUSD`, `U30USD` — tutti e tre con muro **`2024.09.26`** e
   *«IL BROKER NON HA PIÙ STORICO»*. Su `F40EUR`/`E50EUR`/`100GBP` **nessuna misura**.
   🔴 **E il rilievo che ne discende**: `backtest_pipeline/ini/valid_MaxMin_F40EUR.ini` porta
   `Model=4` con `FromDate=2024.01.01` — **nove mesi prima del muro degli altri indici BCM**.
   Se il muro fosse lo stesso, quelle corse hanno usato **tick generati da M1** per il primo
   terzo della finestra, **senza dirlo**. 👉 `[NON VERIFICATO]`: lo chiude la stessa sonda.
2. **Unità (`-PuntiPerIndice`)**: per `F40EUR` è **misurata**, 1 idx = 100 punti MT5
   (`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.105-107, che cita
   `PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` r.352 `[MIS]`). Per **`E50EUR` e `100GBP` è
   `[NON MISURATO]`.** 🔴 Mischiare simboli con `Digits` diversi nella stessa corsa **produce
   una tabella sbagliata senza dirlo** — lo scrive già la riga delle tranche (r.43).

🟢 **E tutti e due i prerequisiti si chiudono con UNO strumento che è già in casa e costa zero
passate**: `mql5/Scripts/ABTG_InfoBroker.mq5` — elenca per ogni simbolo **descrizione, digits,
point, contract size, tick value e la PRIMA DATA disponibile**. È la stessa sonda che nel 14/08
ha mappato il broker esterno.

### 📋 LA SPECIFICA (non la riga: la riga la scrive chi di dovere e passa dal cancello)
| campo | valore |
|---|---|
| **passo 0** | `ABTG_InfoBroker` sui 3 simboli → `Digits`, `Point`, **prima data tick**. Se la prima data è **dopo `2024.09.26`**, la finestra della corsa si accorcia a quella, **dichiarandolo** |
| **passo 1** | `ABTG_SpreadOrario` via `RIGA_SPREAD_FLOTTA.ps1` con `-Simboli "F40EUR"` **da solo** se le `Digits` divergono, altrimenti i tre insieme |
| `-PuntiPerIndice` | **100** per `F40EUR` `[MIS]`. Per `E50EUR`/`100GBP` **si prende dal passo 0**, non si assume |
| `-Da` / `-A` | `2024.09.26` → `2026.06.30`, **salvo accorciamento dal passo 0** |
| **ore che contano** | **07-17 server BCM** (cassa europea; `MaxMinNotte` piazza a **07:59** e chiude **17:30**) **+ 23-05** (il box notturno del motore). 🔴 Non la media di giornata |
| **output** | `spread_orario_F40EUR.csv`, `spread_orario_E50EUR.csv`, `spread_orario_100GBP.csv` + `REFERTO_SPREAD_FLOTTA.txt` |
| **controllo di sanità** | `blocchi persi = 0` e `% SOLO-BID < 5%`. Sopra il 5%, ogni corsa a `Spread=0` su quel simbolo **è ottimista** e va rifatta a `Spread = P95` |
| **costo tester** | **0 passate.** Costo vero = RAM + tempo di lettura tick. Riferimento misurato: la corsa del 03/09 ha letto **156 milioni** di tick su `NASUSD` e **31 milioni** su `D30EUR` con `blocchi persi = 0` |

### 🔓 COSA SBLOCCA — **e cosa NON sblocca**, che è la parte importante
🟢 **Sblocca**: la riga **costo** del *certificato di morte* di `ABTG_MaxMinNotte` sui tre
gemelli. Oggi quei tre stanno a `[NON CALCOLABILE]`, che **non è** «escluso per costo»: senza
spread la frontiera `stop >= 40 x spread` **non si compila né in verde né in rosso**.

🔴 **NON sblocca il round da 24 passate** (`InpMgmtTF` sui tre simboli) che il pacchetto del
mattino teneva in coda dietro a questo numero — **e va detto, perché è un cambio di
conclusione**. Il motivo è già misurato e sta in
`report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` §4.2:

| simbolo | celle vive | PF mediano | **PF MASSIMO** | DD mediano |
|---|--:|--:|--:|--:|
| `F40EUR` | 54 | 0,682 | 🔴 **0,999** | 17,71% |
| `E50EUR` | 54 | 0,495 | 🔴 **0,840** | 33,28% |
| `100GBP` | 54 | 0,497 | 🔴 **0,672** | 46,37% |

👉 **Su 54 celle per simbolo il PICCO non arriva nemmeno al pareggio.** La regola del **19/08**
è esplicita: su un motore senza edge una griglia più fitta trova **solo picchi di rumore**.
**Quindi lo spread serve a scrivere il certificato, non a riaprire la griglia.** Se dopo lo
spread qualcuno volesse comunque le 24 passate, quella è una **tesi nuova** da scrivere, non
una conseguenza di questa misura.

---

## 2️⃣ L'ATR(10) PER TF SU `D30EUR` — 🟢 **l'80% è già scritto in repo**

### Che cosa serve davvero, letto nel sorgente
`mql5/Experts/ABTG_DAX_M3.mq5`:
- r.38 `InpStAtrPeriod = 10` · r.37 `InpStMult = 3.5` · r.36 `InpTriggerTF = PERIOD_M3`
- r.117 `hAtrTrig = iATR(_Symbol, InpTriggerTF, InpStAtrPeriod)`
- r.67 `InpSLMode = M3SL_SUPERTREND` (default) · r.270 `sl = stLine -/+ buf`

👉 **Lo stop è la distanza dalla linea Supertrend**, e quella linea è costruita su
**`ATR(10)` del TF di trigger × 3,5**. Muovere `InpTriggerTF` su `{M15, M30}` muove lo stop:
ecco perché il cancello di costo dipende da quel numero.

### 🟢 IL NUMERO CHE C'È GIÀ
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §3-§4 — **tabella di scala, `ATR(14)` in punti
indice**:

| simbolo | W | **M15** | **M30** | **H1** | **H4** | tag |
|---|---:|---:|---:|---:|---:|---|
| **`D30EUR`** | **780** | **35,0** | **49,5** | **70,0** | **140,1** | `[DERIVATO]` — legge validata **sul simbolo stesso a H4: +0,3%** |

La legge è `ATR(T) = ancora × √(T / W)` con **`W` = minuti ATTIVI** (per il DAX **780** =
08:00-21:00 server), e **non è fittata**: su tutta la forbice plausibile `W ∈ [720, 840]`
l'errore sul misurato resta in **−3,4% … +4,4%**, mentre il `W = 1440` della vecchia legge
sbagliava del **−26,2%**. **Margine dichiarato dagli autori: ±7%.**

Dall'ancora implicita (`35,0 / √(15/780)` = **252,4**) la stessa legge dà anche il TF vivo:
**`ATR(14) M3 ≈ 15,7`** e **`M5 ≈ 20,2`** punti indice `[DERIVATO]`.

### E lo spread del DAX **è misurato** — quindi la frontiera si compila già
`spread_flotta/spread_orario_D30EUR.csv`, mediana in punti indice per ora server:
**h08 = 1,70 · h09-h16 = 1,60-1,70 · h17-h20 = 2,60-2,70**. La sedia lavora **08:30-17:00**
(r.48-51) → **spread di riferimento 1,70**, frontiera **`40 × 1,70 = 68,0 punti indice`**.

| `InpTriggerTF` | `ATR(14)` `[DER]` | banda ST larga `3,5 × ATR` | contro la frontiera 68,0 |
|---|--:|--:|---|
| **M3** *(il vivo)* | 15,7 | **54,8** | 🔴 **sotto**, anche al massimo della banda |
| M5 | 20,2 | 70,7 | 🟠 appena sopra |
| **M15** | 35,0 | **122,5** | 🟢 sopra |
| **M30** | 49,5 | **173,3** | 🟢 sopra |

> 🔴 **Come si legge questa tabella, e come NON si legge.** `3,5 × ATR` è la **banda larga**
> del Supertrend, cioè un **limite superiore** della distanza prezzo→linea: la distanza vera
> oscilla fra ~1× e 3,5× ATR a seconda di dov'è il prezzo dentro il canale. Quindi la riga
> **M3 in rosso è robusta** (se non passa nemmeno al massimo, non passa), mentre **M15 e M30 in
> verde sono `[NON CONCLUSI]`**: al centro del canale potrebbero scendere sotto 68,0.

### 📋 LA SPECIFICA — cosa resta davvero da misurare, ed è poco
| cosa | perché | come, a **0 passate di tester** |
|---|---|---|
| **il rapporto `ATR(10) / ATR(14)`** su `D30EUR` a M3/M15/M30 | in repo c'è solo l'`ATR(14)`. Il rapporto è tipicamente vicino a 1 ma **non è misurato in casa**, e un numero inventato qui vale zero | uno **Script** che chiama `iATR(sym, TF, 10)` e `iATR(sym, TF, 14)` e stampa la **mediana** dei due sullo storico. **Non esiste ancora**: il parente più vicino è `mql5/Scripts/ABTG_SondaADR.mq5`. È una **modifica da ~20 righe**, e passa dal cancello |
| **la distanza VERA prezzo→linea Supertrend**, in multipli di ATR | è quella che decide M15/M30, non la banda larga | 🔴 **Cercata e NON trovata.** `risultati_prove/SONDA_SUPERTREND_TF_BASSI_20260922.txt` (22/09) **l'ho aperto**: misura la qualità del **segnale di flip** (5 famiglie, PF netto) su `GRXEUR`/`SPXUSD` **2013-2018 su dati esterni** — **non** la distanza prezzo→linea, **non** su `D30EUR` BCM. Lo strumento più vicino resta `backtest_pipeline/sonda_supertrend_segnali.py`, **da estendere** |
| **quale ora** | il motore entra **08:30-17:00** | già fatto qui sopra: spread 1,70, frontiera 68,0 |

🔓 **Sblocca**: la frontiera del costo di `DAX_M3`, oggi ferma su un `[NON MISURATO]` pieno.
🟢 **E la novità di oggi**: la frontiera è **già compilabile con margine dichiarato ±7%**, e
dice una cosa che non era scritta da nessuna parte — **è il TF VIVO (M3) a stare sotto la
frontiera**, non i TF candidati. Il round `InpTriggerTF {M15, M30}` **non è un allargamento
opportunistico: è la via d'uscita da un TF fuori costo.**

---

## 3️⃣ `Max barre nel grafico` SUL BANCO `50504400` — 🟢 **CHIUSO, il numero c'è dal 09/09**

**Era dichiarato `[NON MISURATO]`. Non lo è.** Due referti indipendenti, stessa mattina, stesso
terminale:

```
backtest_pipeline/risultati_prove/ibretest_p0/REFERTO_ROUND_P0IBRTNAS.txt
backtest_pipeline/risultati_prove/ibretest_p0/REFERTO_ROUND_P0IBRTDAX.txt
  data            : 2026-09-09 08:43:48   /   2026-09-09 08:42:38
  terminale       : C:\MT5_Backtest\terminal64.exe
  tetto barre     : MaxBars=10000000
```

ed è già citato in chiaro in `report/P0_IBRETEST_NASUSD_2026-09-09.md` r.4 — **nessuno l'aveva
collegato al pre-volo**.

**Il cancello di classe 160**, letto nel codice (`backtest_pipeline/righe/RIGA_ROUND_VPS.ps1`
r.987-1001): muore **solo se `1000 <= MaxBars < 200000`**.
👉 **10.000.000 passa con quattro ordini di grandezza di margine.** ✅

E la macchina dove i round girano **davvero** dopo la firma del 21/09 ha il suo numero, pure
misurato: **PC di backtest → `MaxBars=100000000`**, letto nel referto di `R202A` del 21/09
(`backtest_pipeline/righe/RIGA_R202A_DA_MANDARE.md` §②). ✅

| macchina | terminale | `MaxBars` | quando | pre-volo cl.160 |
|---|---|--:|---|---|
| **PC di backtest** | `C:\Program Files\BCM Markets MT5 Terminal` (**50503392**) | **100.000.000** | 21/09/2026 | 🟢 passa |
| **VPS** | `C:\MT5_Backtest` (**50504400**) | **10.000.000** | 09/09/2026 | 🟢 passa |

### ⚠️ I due limiti, dichiarati
1. `MaxBars` vive in `config\common.ini`, che **MT5 riscrive all'uscita**: il valore è quello
   del **09/09**, non necessariamente quello di oggi. 🟢 **Ma non serve una sonda**: il driver
   lo **ristampa nel referto di ogni corsa** (r.1203). Il numero si riconferma **gratis alla
   prossima corsa**, non prima.
2. 🔴 **La domanda era mal posta, e va detto**: il banco `50504400` è **sul VPS** e per la firma
   del 21/09 **sta spento** finché la challenge opera. Il pre-volo che conta oggi è quello del
   **PC di backtest**, ed è **verde**.

---

## 🕳️ NON COPERTO — per nome

1. 🔴 **La distanza vera prezzo→linea Supertrend su `D30EUR`**: `[NON MISURATO]`. L'ho
   **cercata** nel file che sembrava contenerla
   (`backtest_pipeline/risultati_prove/SONDA_SUPERTREND_TF_BASSI_20260922.txt`, 22/09) e **non
   c'è**: quel file misura il **PF netto delle cinque definizioni di flip** su `GRXEUR` e
   `SPXUSD`, finestra **2013-2018 su dati esterni**, TF 5/15/30 min — un'altra domanda e un
   altro mercato. Senza quel numero le righe **M15/M30** della tabella §2 restano
   `[NON CONCLUSE]`, non verdi.
2. 🔴 **Profondità dei tick reali di `F40EUR`, `E50EUR`, `100GBP`**: `[NON MISURATO]`. E con
   essa resta aperto il sospetto che `valid_MaxMin_*.ini` (`Model=4`, `FromDate=2024.01.01`)
   abbia girato su **tick generati** per i primi nove mesi. `[NON VERIFICATO]`.
3. 🔴 **`Digits`/`Point` di `E50EUR` e `100GBP`**: `[NON MISURATO]`. Senza, `-PuntiPerIndice`
   sarebbe un'assunzione, e una tabella di spread con l'unità sbagliata **è peggio di nessuna
   tabella**.
4. 🔴 **Lo script dello spread non sa girare sul PC di backtest**: `$BANCO_PERC` è **cablato**
   a `C:\MT5_Backtest` (r.265). Serve una **modifica allo script** (parametro di bersaglio) o
   una **deroga firmata** alla regola del 21/09. **Non ho toccato lo script**: è una modifica,
   e le modifiche passano dal cancello.
5. 🔴 **Il rapporto `ATR(10)/ATR(14)`**: `[NON MISURATO]`, e **lo strumento che lo misura non
   esiste ancora** (`ABTG_SondaADR.mq5` è il parente, non il gemello).
6. 🔴 **Tempo macchina in minuti** della corsa spread sui tre europei: `[NON MISURATO]`.
   L'unico riferimento è il volume di tick della corsa del 03/09 (156M su `NASUSD`), che **non
   è un tempo**.
7. 🔴 **`SPXUSD`, `E35EUR`, `200AUD`**: hanno lo **stesso buco di spread** dei tre di questo
   dossier e **non sono in nessuna tranche**. Li nomino perché un insieme definito «i tre del
   mandato» lascerebbe fuori tre simboli con lo stesso problema (classe 180).

---

## 📌 IN SINTESI, per chi decide

- **Una sonda su tre non va fatta** (§3): il numero c'è, e su **due macchine**, tutte e due
  verdi al pre-volo.
- **Una è già risposta all'80%** (§2), e la risposta **ribalta la domanda**: il TF **vivo** di
  `DAX_M3` (M3) è quello **sotto** la frontiera del costo.
- **Una è davvero aperta** (§1), costa **zero passate di tester**, **ma non è lanciabile
  com'è**: lo strumento punta a un terminale che la firma del 21/09 tiene spento. 👉 La cosa da
  decidere **non è se misurare: è su quale macchina**.
