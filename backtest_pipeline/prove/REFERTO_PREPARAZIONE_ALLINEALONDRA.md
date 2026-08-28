# 🧾 REFERTO DI PREPARAZIONE — PASSO 0 **ALLINEA LONDRA**

**Data:** 28/08/2026 · **Oggetto:** `mql5/Experts/ABTG_AllineaLondra.mq5`
(candidato **P2** della caccia intraday forex/oro del 28/08) · **Simbolo:**
`EURUSD M15`.

> 🔴 **QUESTO DOCUMENTO NON CONTIENE LA RIGA DI LANCIO, ED È VOLUTO.**
> La riga esiste in **UN SOLO POSTO** — `righe/RIGA_ALLINEALONDRA_DA_MANDARE.md` —
> perché un blocco `powershell` incollato in un secondo file **scade** (pin vecchio
> + marcatore vecchio si proteggono a vicenda e la guardia `SCRIPT VECCHIO` li
> lascia passare: **CHECKLIST punto 100**, pagato il 28/08 sul PASSO 0 dell'FVG).
> **Un link non può scadere, un blocco sì.**

---

## 1. CHE COSA È, E CHE COSA NON È

**È** un **conta-operazioni**: misura quante operazioni produce il motore
(allineamento di 5 medie dentro la finestra di Londra) **prima** di qualunque
lettura di merito — valvola **R59**, Emendamento della finestra **regola A**
(*"l'unità di misura è l'OPERAZIONE, non l'anno"*).

**NON è** un round, **non** dà verdetti, **non** promuove e **non** boccia niente.
Il PF che esce dal CSV **si legge ma non si giudica**: non ci sono criteri di
merito firmati e quattro celle non sono un round. **Nessuna sedia viva viene
toccata.**

**La domanda per cui il giro esiste davvero** è la **cella di ablazione**. Il
dossier P2 dichiara da solo l'adiacenza concettuale con `ABTG_SuperWave`,
`ABTG_CrossEma` e `ABTG_GoldenCross` (*"sono tutti motori di allineamento di
medie; la differenza è il **contenitore**, non il segnale"*) e mette il carico
della prova su chi propone. `InpUsaFinestraSessione` è quindi **l'asse
principale**, e le **cinque medie restano CONGELATE** ai default dell'autore
(3/6/9/50/200) — come il mandato del costruttore dell'EA impone: *"nel primo
round si spazzola la sessione, non le medie"*.

---

## 2. GLI ARTEFATTI PRODOTTI

| file | cosa contiene |
|---|---|
| `backtest_pipeline/prove/PASSO0_ALLINEALONDRA_00_finestra.txt` | **la baseline** + ipotesi, tre esiti A/B/C, tutte le avvertenze di banco (scritte **una volta sola**, le altre celle le citano) |
| `backtest_pipeline/prove/PASSO0_ALLINEALONDRA_01_nofinestra.txt` | 🔴 **la cella di ablazione** + l'effetto di secondo ordine dell'interruttore |
| `backtest_pipeline/prove/PASSO0_ALLINEALONDRA_02_long.txt` | solo long + perché le celle dei lati esistono nonostante le colonne |
| `backtest_pipeline/prove/PASSO0_ALLINEALONDRA_03_short.txt` | solo short |
| `backtest_pipeline/righe/RIGA_ALLINEALONDRA.ps1` | il driver, marcatore `MARCATORE_RIGA_ALLINEALONDRA_v1` |
| `backtest_pipeline/righe/RIGA_ALLINEALONDRA_DA_MANDARE.md` | **la pagina da mandare a Claudio — l'unico posto in cui la riga esiste** |
| questo file | il verbale della preparazione |

---

## 3. LE QUATTRO CELLE × I DUE BANCHI

| cella | delta dal `00` | magic gemelli | `Finestra Sessione` attesa | `Minuto Flat` atteso |
|---|---|---|---|---|
| `00_finestra` | — (baseline) | 777600 / 777601 | **1** | **630** (10:30) |
| 🔴 `01_nofinestra` | `InpUsaFinestraSessione` 1→0 | 777610 / 777611 | **0** | **1424** (23:44) |
| `02_long` | `InpAllowShort` 1→0 | 777620 / 777621 | **1** | **630** |
| `03_short` | `InpAllowLong` 1→0 | 777630 / 777631 | **1** | **630** |

**Ablazione a STELLA**, non a scala: ogni cella differisce dalla baseline di **due
righe sole** (l'interruttore + il magic), e il driver lo verifica **prima** di
aprire MT5.

### 3.1 Verifica dei magic — **eseguita, non asserita**

Blocco `7776xx`, cercati **uno per uno** in tutto il repo (escluso `.git`) il
28/08/2026:

```
777600: 1 occorrenza  -> e' il default del sorgente ABTG_AllineaLondra.mq5, riga 263
777601: 0    777610: 0    777611: 0
777620: 0    777621: 0    777630: 0    777631: 0
```

Nessuno degli otto è mai stato usato da una sedia o da un round. La lista dei
**vietati** del driver copre: il sorgente `775501`, i PASSO 0 gemelli di oggi
(`7734xx` VWAPREV, `776xxx` FVG, `7772xx` OROLOGIO, `778xxx` G1-PAOLO), le sedie
vive e i blocchi dei round recenti — **69 magic**, e il driver si ferma se ne
trova uno (verificato facendolo fallire).

### 3.2 I due banchi, e perché **due date diverse**

| banco | modello | finestra | natura del vincolo |
|---|---|---|---|
| **S** | 1 — OHLC M1 | `2022.07.01 → 2026.06.30` | 🔴 **DERIVATA**, non misurata: tetto delle **~100.000 barre** del tester, che a M15 vale **~4 anni**. Stessa convenzione e **stessa data di R108** (`RIGA_R108_BB_M15.ps1` riga 224) |
| **V** | 4 — TICK REALI | `2024.07.05 → 2026.06.30` | 🔴 **INFERITA**, non misurata su EURUSD: è il pavimento dei tick BCM **misurato su GBPUSD** (R58/R72), esteso per analogia |

⚠️ **Il vincolo del banco S è il TESTER, non il broker:** EURUSD ha storico fino a
**gennaio 1999** (R102). ⚠️ **Il banco S è SOLO SCREENING e non autorizza nessuna
proposta** — lo scrive il driver generico stesso alla riga 65 (*"1 = OHLC M1:
SOLO screening, mai verdetti"*). ⚠️ Se il tester partisse più tardi della data
dichiarata, la **finestra reale è più corta di quella nominale**: è un caveat da
scrivere accanto ai numeri, non un gate.

**32 passate** = 4 celle × 2 banchi × 2 finestre (split 40/60) × 2 gemelle.

---

## 4. ⚖️ L'EFFETTO DI SECONDO ORDINE DELL'ABLAZIONE — **la cosa più importante di questa preparazione**

Con la finestra spenta **il tetto di 2 ingressi al giorno resta acceso**. Quindi
la `01_nofinestra` **non misura** *"lo stesso motore distribuito su tutto il
giorno"*: misura *"lo stesso motore **ancorato a mezzanotte server**"*.

**Letto nel sorgente, non dedotto** (`OnTick` + `ValutaBarraChiusa`):

- `gTradesToday` si azzera al cambio di `tn.day_of_year`;
- `ValutaBarraChiusa` esce con `if(gTradesToday >= InpMaxTradesDay) return`;
- un allineamento a 5 medie è uno **STATO**, non un evento: resta vero per molte
  barre di fila.

➡️ I due ingressi cadranno tipicamente **nelle prime barre M15 dopo le 00:00
server**, non "in giro per la giornata". La differenza `00` − `01` si riporta
quindi come un **PACCHETTO**:
`(finestra d'ingresso rimossa)` **+** `(ancoraggio a mezzanotte server)`.

**È la regola del punto 97-bis** (*in una gamba CON/SENZA si elencano gli effetti
di secondo ordine PRIMA di chiamare "costo" la differenza*), e sta scritta in
**tre posti**: nel file prova della cella, nel referto che il driver produce
(**accanto** al confronto, non in fondo) e nella pagina da mandare.

**Chi volesse il motore davvero libero** deve alzare **anche** `InpMaxTradesDay`:
sarebbe una cella a **due righe mosse**, cioè un'altra misura — e **questo giro
non ce l'ha**, dichiarato. La colonna `Giorni Tetto Bloccante` dice quante
giornate il tetto ha davvero morso.

**La stessa avvertenza è stata riletta contro TUTTE le celle** (97-bis, seconda
metà: *un'avvertenza copiata su 2 celle su 3 è peggio del silenzio*). Per le celle
dei lati vale al rovescio: con un lato spento **slot e tetto restano liberi**,
quindi `n(02_long) + n(03_short)` sarà **maggiore** di `n(00_finestra)`.

🟢 **E una cosa che si poteva temere e NON c'è, verificata nel sorgente:**
`AllineaLong_Calc` e `AllineaShort_Calc` sono **mutuamente esclusivi** per
costruzione (il prezzo non può stare sopra tutte e cinque le medie e sotto tutte
e cinque nella stessa barra), quindi l'ordine in cui `SegnaleAllineamento()` li
prova **non dà priorità al long**. L'unica interferenza fra i lati è quella dello
**slot** (`ContaPosizioni()`, filtrata per magic **e** simbolo) e del **tetto**.

---

## 5. I GATE DEL DRIVER

### 5.1 Prima di aprire MT5 — sui file prova

Sintassi a **5 campi** · **elenco chiuso** dei parametri ammessi (impedisce a una
griglia di rientrare dalla finestra) · **un solo asse Y**, e dev'essere
`InpMagic` · **geometria** (`@SIMBOLO` / `@PERIODO` / `@DAQUANDO`) confrontata coi
**valori dichiarati nel driver**, non coi parametri (punto **96-bis**) ·
**valori assoluti** degli interruttori per cella (prende i file **scambiati**) ·
**baseline assoluta** contro costanti dichiarate nel driver (prende la
**corruzione simmetrica**, che nessun diff può vedere — lezione R110) ·
**stella** contro il `00_finestra` · **magic** vergini, unici, mai vietati (nei
tre controlli l'ordine è parte del gate: prima il **pericolo**, poi lo
scostamento innocuo).

### 5.2 Dopo la corsa — **sulle COLONNE del CSV**, non nella scheda Esperti

In ottimizzazione le `Print` girano sugli agent e **non le legge nessuno**
(punti 34 e 99). L'EA porta il collaudo dentro il CSV (**29 colonne**) e il driver
ne fa dei gate:

| colonna | gate |
|---|---|
| `Autotest Falliti` | ≠ 0 (o `-1` = **non eseguito**, che non è "passato") → **PROBLEMA** |
| `Notti Attraversate` | > 0 → **PROBLEMA** (mandato FTMO *"mai overnight"* non rispettato) |
| `Finestra Sessione` | ≠ dall'atteso per cella → **PROBLEMA**. 🔴 **È IL gate dell'ablazione** (punto 52: dimostra che l'interruttore è arrivato **dentro il tester** e non è stato reso inerte) |
| `Minuto Flat Calcolato` | ≠ 630 / 1424 → **PROBLEMA** |
| `Minuto Inizio/Fine Ingressi/Fine Sessione` | ≠ 180/525/645 → **PROBLEMA** |
| `Flat Anticipo Min` | ≠ 15 → **PROBLEMA** |
| `Ingressi Saltati Spread` | > 0 col filtro pinnato a 0 → **PROBLEMA** (canarino: il file prova che ha girato non è quello che crediamo) |
| `Lotti Al Minimo` | > 0 → **RILIEVO** (rischio reale > 0,65%) |
| `Ingressi Totali` | = 0 → **RILIEVO** (cella muta) |
| `Trades` | < 150 → **RILIEVO** (merito sospeso, rischio no) |
| gemelli | due righe non identiche al centesimo → **PROBLEMA** |

⚠️ **I gate si contano sulle righe gemelle e si scrivono UNA VOLTA SOLA.** Nella
prima stesura stavano dentro un `foreach` sulle righe: due gemelle sporche
producevano **due messaggi identici**, cioè **192 PROBLEMI per 12 difetti veri**.
Un elenco che nessuno legge fino in fondo non protegge niente. Il conteggio
(*"su N righe gemelle"*) resta, perché un difetto su **una** sola gemella è un
fatto diverso da uno su **tutte e due**.

### 5.3 Le due sentinelle che non si confrontano fra loro

- **due corse vuote** (`n = 0` su tutte e due le gemelle) escono identiche **per
  costruzione**: il driver **non** le chiama "banco deterministico", le chiama
  `NON MISURATO` (punto **93**);
- i campi non misurati escono `n/d`, **mai** come numeri plausibili (punto 66),
  con quattro formattatori distinti — e il **profitto** e la **peggior giornata**
  conservano il segno negativo, perché lì il negativo è un **risultato**, non una
  sentinella.

---

## 6. 🧩 LA RICOMPOSIZIONE — risolta **dentro lo script**

L'ablazione è un criterio **DI INSIEME** (serve la `00` **e** la `01`). Girare una
cella per volta produrrebbe referti che dicono tutti *"non misurato per intero"*:
è il difetto del **punto 101**, pagato sulla Sonda dell'Orologio la stessa
settimana.

Qui il driver, dopo le corse, **rilegge sempre** i CSV di **tutte e quattro le
celle e di tutti e due i banchi** che trova sul disco, e li marca
`RILETTA DA UN GIRO PRECEDENTE`. Le tre domande del punto 101 hanno risposta:
**chi ricompone** (lo script, da solo) · **quanto costa** (zero: è una rilettura)
· **cosa lo invalida** (🔴 **il ri-pin, che cancella `risultati_prove\`**).

E il **punto 101-bis** è coperto: ogni cella porta la riga
`il tester ha girato in questo giro: SI/NO`, calcolata sul `LastWriteTime` del CSV
contro l'istante d'inizio del lancio. **Un numero riletto non si può scambiare per
un numero misurato adesso.**

---

## 7. ✅ COSA È STATO VERIFICATO — **ESEGUENDO**

### 7.1 Analisi statica del `.ps1`

- **parsa**: PowerShell 7.4.6 + `[Parser]::ParseFile` → **0 errori**, 10.505 token;
- **ASCII puro**: **0 byte non-ASCII** (regola del 17/08 — un `.ps1` con un'emoji
  dentro una stringa esplode su PowerShell 5.1 del VPS);
- **non usa `$args`** (variabile automatica, punto 71);
- **0 collisioni case-insensitive** fra nomi di variabile (punto 79 — il primo
  difetto della serie arrivato fino al PC di Claudio);
- **0 parametri orfani** e **0 variabili assegnate e mai rilette** (punto 97):
  ognuno degli undici parametri è **passato** al driver generico **e/o**
  confrontato con una **costante dichiarata**. Il rischio nel referto è letto
  dalla **baseline dichiarata**, non da un parametro.

### 7.2 I gate fatti **fallire uno per uno** — **28 corruzioni, 28 fermate**

Banco stubbato (mirror locale al posto di `raw.githubusercontent`, MetaEditor e
driver generico sostituiti da stub), **controllo positivo eseguito PRIMA e DOPO**
la batteria. Un gate che non scatta mai non è dimostrato.

| corruzione | il gate ha detto |
|---|---|
| i due file dei **lati scambiati** | `'InpAllowLong' vale 0, la cella 02_long lo vuole 1` |
| **ablazione riaccesa** nella `01` | `'InpUsaFinestraSessione' vale 1, la cella 01_nofinestra lo vuole 0` |
| **corruzione SIMMETRICA** su tutti e 4 (`InpAtrSLmult` 1.5→2.0) | `la baseline dichiarata di questo PASSO 0 lo vuole 1.5` |
| magic **vietato** (776000, PASSO 0 gemello FVG) | `magic 776000 e' VIETATO (sedia viva o round recente)` |
| magic **duplicato** fra due celle | `magic 777610 usato in due celle: ...01_nofinestra... e ...03_short...` |
| magic **diverso** da quello dichiarato per la cella | `magic 777650, la cella 00_finestra vuole 777600` |
| `InpMagic` con **passo 0** | `InpMagic ha passo 0 invece di 1: i gemelli non sarebbero due` |
| **secondo asse Y** (la sessione che rientra come griglia) | `deve avere ESATTAMENTE un asse con flag Y, trovati 2 [InpSessStartHour,InpMagic]` |
| **zero assi Y** (sweep dei gemelli spento) | `... trovati 0 []` |
| `@PERIODO` M15→M5 (**trappola R102**) | `@PERIODO e' M5, atteso M15 ... il TF del tester E' la strategia` |
| `@DAQUANDO` cambiato in un file solo | `@DAQUANDO e' 2010.01.01, atteso 2022.07.01` |
| `@SIMBOLO` cambiato in un file solo | `@SIMBOLO e' GBPUSD, atteso EURUSD` |
| riga a **quattro campi** (`Nome=1\|\|\|\|\|\|N`) | `ha 4 campi invece di 5` |
| **parametro doppio** nello stesso file | `DUE righe per 'InpVerbose'. In [TesterInputs] ... ZERO passate` |
| parametro **fuori dall'elenco chiuso** | `'InpComment' NON e' nell'elenco chiuso ... smette di contare e comincia a scegliere` |
| pin della baseline **cancellato** | `manca il pin di 'InpRiskPercent': la baseline dev'essere verificabile nell'.ini` |
| **rischio alzato** 0,65→2,0 in un file solo | `la baseline dichiarata di questo PASSO 0 lo vuole 0.65` |
| una delle **cinque medie congelate** spostata | `'InpSmma4' vale 100, ... lo vuole 50` |
| **autotest spento** (la colonna uscirebbe a −1) | `'InpAutoTest' vale 0, ... lo vuole 1` |
| **anticipo del flat** che si mangia la sessione | `'InpFlatAnticipoMin' vale 600, ... lo vuole 15` |
| riga **in più** in un file (stella) | `ha la riga 'X' che il 00_finestra non ha` |
| riga **in meno** in un file (stella) | `NON ha la riga 'X' che il 00_finestra ha` |
| **pin segnaposto** di 40 zeri | `-Pin e' il SEGNAPOSTO di 40 zeri: la pagina non e' ancora stata pinnata` |
| pin che **non è un commit** | `-Pin deve essere un commit di 40 caratteri esadecimali` |
| `-SoloCella` inesistente | `non esiste. Valide: 00_finestra, 01_nofinestra, 02_long, 03_short` |
| `-SoloBanco` inesistente | `non esiste. Validi: S (OHLC screening), V (tick reali)` |
| `-Periodo M5` passato a mano | `i quattro file prova dichiarano @PERIODO M15 e il gate li confronta` |
| _(controllo positivo, prima e dopo)_ | **nessuna fermata, `ESITO: CONTROLLO COMPLETATO`, uscita 0** |

> 🔎 **La riga più importante è la terza.** Una riga storta **uguale in tutti e
> quattro** i file passerebbe il gate della stella a mani basse — *"un diff fra A
> e B non può accorgersi di niente che sia uguale in A e in B"* (lezione R110). La
> prende il **gate della baseline assoluta**, che confronta con **valori dichiarati
> nel driver**, non con un altro file.
>
> 📌 **E il gate della stella, oggi, è una ridondanza deliberata**, detto perché
> non sembri più di quello che è: **ogni** parametro dell'elenco chiuso è anche
> nella baseline assoluta o è un interruttore dichiarato, quindi le corruzioni
> reali vengono fermate prima. Diventa portante **il giorno che qualcuno aggiunge
> un parametro all'elenco chiuso senza metterlo nella baseline** — ed è così che è
> stato provato (elenco chiuso esteso a tavolino nello stub: **due fermate su
> due**).

### 7.3 Le tabelle e i gate di collaudo, **eseguiti su CSV sintetici**

CSV costruiti con l'**intestazione VERA dell'EA** (29 colonne, letta nel sorgente),
**quattro scenari**:

| scenario | esito misurato |
|---|---|
| **A — sano** | **0 PROBLEMI**, 1 rilievo (righe `[AUTOTEST]` non leggibili nello stub), `ESITO: CORSA COMPLETATO`, uscita **0**. Tabelle 1/2/3 e confronto dell'ablazione **renderizzati per intero** |
| **B — collaudo rotto** (autotest 1, notti 3, spread 7, finestra invertita, flat 999, finestra oraria 180/**600**/645, n=40, lotti al minimo 5) | **96 PROBLEMI** = 8 celle-banco × 2 finestre × **6 gate**, ognuno col messaggio giusto; **33 rilievi**; uscita **1** |
| **C — gemelli diversi** | **8 PROBLEMI**: `gemelli IS=DIVERSI su profitto: 1234.56 contro 999 ... il banco NON e' deterministico` |
| **D — due corse vuote** (`n=0` su entrambe le gemelle) | **8 PROBLEMI**: `NON MISURATO (ZERO operazioni in tutte e due le passate: due corse vuote escono identiche per costruzione)` — **non** scambiate per "banco deterministico" |

### 7.4 Difetti trovati **nella nostra stessa riga**, e corretti prima dell'invio

1. 🔴 **`Join-Path` su una variabile d'ambiente vuota LANCIA** (non torna `$null`):
   il raccoglitore delle righe `[AUTOTEST]` — dichiarato **best-effort** — faceva
   morire la corsa. Ora le radici si costruiscono una per una e solo se la base
   esiste. *(Un best-effort che può uccidere la corsa è l'esatto contrario del suo
   mestiere.)*
2. **Tabella 1 con due colonne `n IS` / `n OOS` ripetute uguali** sulle righe IS e
   OOS: due numeri giusti messi dove non si possono leggere. Ora è **una riga per
   finestra**, con una sola colonna `n`.
3. **Gate di collaudo duplicati** per riga gemella (vedi §5.2): 192 → 96 problemi,
   con il conteggio delle gemelle colpite.
4. 🔴 **Due trappole nella ricetta di pinnatura, tutte e due dello stesso tipo —
   _lo strumento che si include nel proprio perimetro_** — trovate **eseguendo la
   ricetta su una copia**:
   - il terzo conteggio (`grep -ci "segnaposto|non funziona"`) **non poteva mai
     dare 0**, perché quelle parole stanno anche nella ricetta e nella prosa che la
     spiega. Sostituito con un **token unico** cercato con le parentesi quadre;
   - il `sed` che toglie il cartello del segnaposto, scritto **coi marcatori per
     intero**, cancellava il cartello, poi **incontrava la propria riga di
     ricetta**, riapriva l'intervallo e **cancellava la pagina fino in fondo**:
     **da 457 righe a 148**. La pagina di lancio decapitata **proprio mentre la si
     pinna**. Corretto con `[-]`; e la stessa trappola è riscattata una seconda
     volta dalla **spiegazione** del difetto (457 → 169), che ora non scrive più i
     marcatori per intero.
   - ✅ **Ricetta ri-eseguita dopo la correzione**: `3 / 0 / 0`, **11 righe rimosse
     (solo il cartello)**, riga nuda e riquadro del pin sostituiti.

### 7.5 Analisi statica del `.mq5` (l'EA non è nostro, ma il PASSO 0 lo è)

- **header a 29 nomi = 29 specificatori `StringFormat` = 29 argomenti**, contati a
  macchina; `stats[27]` con `stats[0..26]` **tutti assegnati e contigui**;
- **graffe / tonde / quadre bilanciate** (108/108, 592/592, 77/77) su sorgente
  ripulito da commenti e stringhe con uno scanner a stati;
- 🔴 **scan delle RIDICHIARAZIONI nello stesso scope** (punto **98**, il difetto che
  il 28/08 ha impedito la compilazione del VWAP Revert): **zero**;
- **nessun input orfano**: **33 input su 33** sono usati nel codice;
- **ASCII puro**: 0 caratteri non-ASCII.

---

## 8. 🟡 COSA **NON** È VERIFICATO, e va detto

- **la COMPILAZIONE**: qui non esistono MetaEditor né Strategy Tester. L'EA **non
  è mai stato compilato da nessuno**. Per questo il giro di controllo della riga
  **compila davvero**: è il **primo risultato vero** di questo PASSO 0. Se
  fallisce, **quello è il risultato** e va riportato così com'è;
- **l'esito dell'AUTOTEST** (8 blocchi) sui dati veri;
- **il comportamento del FLAT sui tick veri** — la colonna `Notti Attraversate`
  esiste apposta: il flat vive dentro `OnTick`, e se il simbolo smette di mandare
  tick prima dell'ora di flat la chiusura slitta;
- **se i tick reali di EURUSD arrivino davvero al 2024.07.05** (misurato su
  GBPUSD, qui **inferito**);
- **se il tester legga davvero dal 2022.07.01 a M15** (data **derivata** dal tetto
  delle 100.000 barre, non misurata);
- **la durata** della corsa e **ogni singolo numero**;
- 🟢 **IL PIN — messo e verificato il 28/08 sera, terza pinnatura**: `21cec02…`,
  otto artefatti confermati blob-identici al working tree. Al momento della
  consegna di questo referto il pin era ancora un segnaposto di 40 zeri; la
  sessione principale l'ha pinnato dopo il push (`9ed66e2…`), il verificatore
  ha trovato 6 difetti, ri-pinnato (`23bb983…`), il verificatore ha trovato
  ancora 2 difetti (una quarta copia di un errore già corretto altrove tre
  volte), ri-corretto e ri-pinnato all'attuale — come da passo 10 sotto.

---

## 9. 🚩 QUELLO CHE IL GIRO **NON** MISURA (e che non va chiesto al referto)

1. **La SCORRELAZIONE dalle sedie long della flotta.** Il dossier avvisa da solo:
   è un motore **a favore del trend**, correlato alle sedie long nelle mattine di
   trend forte. Si misura sulle **serie per-trade**, non qui.
2. **Il COSTO (spread).** Il filtro è spento **apposta**, per misurare il motore
   nudo. 🔴 **Nessuna cella si promuove così** (lezione R55).
3. **L'ORA GIUSTA.** `03:00 / 08:45 / 10:45` sono i **numeri letterali del Pine**
   letti come **ora server**: un **punto di partenza dichiarato**, non una
   conversione di fuso (il Pine li scrive nel fuso *dello scambio*, tipicamente
   UTC). La conversione a tavolino è la trappola già pagata in casa. **La sessione
   è l'asse del primo round vero, e quello è un altro giro.**
4. **Il MERITO.** Nessuna promozione, nessuna proposta, nessuna sedia toccata.

---

## 10. ➡️ IL PASSO DOPO

1. ✅ **Push** degli otto artefatti sul branch `lavoro` — fatto;
2. ✅ **pinnatura** della pagina con la ricetta e **rimozione del cartello del
   segnaposto** nello stesso passo — fatto, prima pinnatura `9ed66e2…`;
3. ✅ verifica `git cat-file -s <pin>:<file>` sugli **otto** artefatti — fatto;
4. ✅ **verificatore-stringhe**, prima passata — FAIL con 6 difetti, tutti
   corretti, ri-pinnato `23bb983…`;
5. ✅ **verificatore-stringhe**, seconda passata — FAIL con 2 difetti (una
   quarta copia di un errore già corretto tre volte altrove), corretto,
   ri-pinnato all'attuale `21cec02…`, tutti e otto gli artefatti riconfermati
   blob-identici;
6. **solo dopo**, la riga va a Claudio — e il primo giro è quello di **controllo**,
   che è anche la **prima compilazione** dell'EA.

**La riga da mandare sta in `backtest_pipeline/righe/RIGA_ALLINEALONDRA_DA_MANDARE.md`
ed è l'unico posto in cui esiste.**
