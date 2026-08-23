# 🥇 R99 — LA RIGA DA MANDARE (l'oro su 22 anni, la misura del RISCHIO)

_Scritta il 23/08/2026, dopo la firma di Claudio (**"FIRMO R99, PARTIAMO CON
L'ORO"**)._

> ## ✅ STATO — **VERIFICATA il 23/08/2026, con UNA CORREZIONE APPLICATA**
> Il verificatore ha installato **PowerShell 7.4.6** e ha fatto il parse reale
> del driver (`Parser::ParseFile` → **0 errori**), più i parser del round
> riprovati **a cultura `it-IT` attiva**.
> 🔴 **Trovato e RIPRODOTTO un difetto che sarebbe arrivato a Claudio come
> verde pieno**: `LeggiDeal` leggeva profitto e saldo **contando le celle dalla
> fine**, e la tabella dei deal di MT5 ha in coda una colonna
> `Comment`/`Commento` (questo EA ci scrive `STREV OTT`). Misurato sui due
> campioni: **con** la colonna il **CRITERIO B** usciva `0,00%` con la data
> **vuota**; **senza**, la stessa storia dava `-3,52%`. Uno dei **tre numeri
> firmati**, contro il muro prop del **5%**.
> **Corretto** (colonne trovate per **intestazione**, etichette IT+EN;
> intestazione irriconoscibile → `NON MISURATA`; niente pavimento a `0.0` sul
> minimo) e **ripinnato**. Nuova classe in checklist: **punto 58**.

Criteri: `backtest_pipeline/risultati_archivio/R99_CRITERI.md` — **FIRMATI il
23/08/2026**, a numeri mai visti. Questa riga **non cambia i criteri**: li
traduce in file eseguibili, e ogni traduzione è dichiarata (§🧾).

---

## 📌 IL PIN — `46276278f7d293b954e355e5c09d432b96c5af50`

⚠️ **Ripinnato dal verificatore il 23/08**: il pin precedente
(`9ce568c…`) conteneva il difetto del `LeggiDeal` (§STATO). **Non si usa più.**

È il commit che contiene **questo** driver corretto, **il file prova completato**
e i criteri firmati (checklist 4: se il commit di un file pinnato fosse **più
nuovo** del SHA scritto qui, il SHA sarebbe una bugia).

Verificato con `git log -1 --format=%H -- <file>` + `git merge-base
--is-ancestor` su **ognuno** dei sei file che la riga scarica: tutti ≤ il pin.
E il contenuto servito da `raw.githubusercontent.com` **a quel SHA** è stato
riscaricato e confrontato byte a byte col locale: **identico** (108.456 byte),
contiene la correzione e il marcatore. Cache CDN esclusa **per misura**, non
per attesa (checklist 6).

| file scaricato dalla riga | marcatore preteso dal driver | esito della verifica |
|---|---|---|
| `prove/R99_ORO_22ANNI_RISCHIO.txt` | `@SIMBOLO`, **45 righe vive** (3 direttive + 42 parametri) | ✅ misurate con `grep -vE '^\s*(#\|$)' \| wc -l`, non ricordate |
| `mql5/Experts/ABTG_SupertrendReversal_Ottimizzato.mq5` | `[STReversal]`, `#property version "1.00"`, `InpMagic = 970901`, `ABTG_PausaGuardian.mqh`, `%s mercato %.2f lot` | ✅ tutti e cinque presenti |
| `mql5/Include/ABTG_PausaGuardian.mqh` | `ABTG_GuardiaIngresso`, ≥ 4.000 byte | ✅ **82.941 byte** |
| `backtest_pipeline/scarica_storico.ps1` | `REFERTO STORICO`, `AllowLiveTrading=false`, `$EABranch = "lavoro"` | ✅ (con gli spazi: la regex del driver è `\$EABranch\s*=\s*"lavoro"`) |
| `report/CONTRATTI_SEDIE.md` | `DD promesso` | ✅ |

⚠️ **Il driver ri-pinna da solo `scarica_storico.ps1`** (ha `$EABranch =
"lavoro"` scritto fisso e riscaricherebbe l'`ABTG_HistoryDownloader` dalla
**punta** del branch — difetto 24) e **verifica lo stato finale** invece di
fidarsi del replace.
⚠️ **`walkforward_generico.ps1` NON viene usato**, e non è una svista: quel
driver spacca sempre la finestra in **IS 40 / OOS 60**, mentre il **CRITERIO A**
chiede il DD **su tutta** la finestra `2004.06.11 → 2026.06.30`. R99 scrive i
propri `.ini` e li passa a `terminal64 /config`, esattamente come fa il PASSO 0
di R98.

---

## ⛔ PRIMA DI LANCIARE — traffico e prerequisiti

- **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: prima di
  lanciare, dichiarare che non c'è nessun altro round in corso.
- **MT5 E METAEDITOR CHIUSI.** Lo script si rifiuta di partire se li trova
  aperti (col terminale aperto il tester non gira → zero risultati; con
  MetaEditor aperto `metaeditor64 /compile` torna subito senza compilare).
- 🔴 **QUESTA RIGA RICOMPILA UNA SEDIA VIVA.**
  `ABTG_SupertrendReversal_Ottimizzato` è in flotta su XAUUSD H4. Lo script
  copia il `.mq5` **del pin** in `MQL5\Experts` del terminale di backtest e lo
  ricompila. Perciò, e sta scritto nel codice:
  - **backup DATATO** di `.mq5` **e** di `.ex5` prima di toccarli, mai
    sovrascritto (checklist 12);
  - verdetto di compilazione = **`LastWriteTime` del `.ex5` prima/dopo**, non
    "esiste";
  - se la compilazione **fallisce**, il `.mq5` viene **rimesso com'era**:
    sorgente e binario restano la stessa versione (checklist 54).
  - Tutti gli `.ini` che la riga lancia hanno `[Experts] AllowLiveTrading=false`.
- **Non tocca nessun per-trade di nessuna sedia**: questo EA **non ne scrive**
  (§🛠️). L'unico file che la riga cancella in `MQL5\Files` è il proprio
  `OptResults_*`. **`bases\<server>\ticks` non viene toccata.**
- **Magic**: blocco **`7799xx` vergine**. Vietati e controllati nel codice:
  **970901** (la sedia viva), **770901** (la collisione del 22/08), **770921**,
  **770924**.
- **Durata**: **[STIMA] 2–6 ore**. La **prima** passata può durare molto più
  delle altre, perché MT5 si scarica le barre M1 di 22 anni **mentre gira**.
  `-OreMax` è **12** ed è un tetto sull'**inizio** di nuove finestre, non
  un'interruzione.

---

## 1️⃣ PRIMA il giro a vuoto (~1 minuto, nessuna passata di test)

> ⚠️ **Non è a costo zero sul terminale**: il giro a vuoto scarica 4 file
> (file prova, `.mq5`, `.mqh`, `CONTRATTI_SEDIE.md` — **non** `scarica_storico.ps1`,
> che serve solo alla corsa vera),
> **installa `ABTG_PausaGuardian.mqh`** e **ricompila l'`.ex5`** (con backup
> datato). Quello che **non** fa è aprire MT5 per testare: **zero passate, zero
> CSV, cache del tester NON svuotata, niente cancellato.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='46276278f7d293b954e355e5c09d432b96c5af50'; $p="$env:USERPROFILE\RIGA_R99.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R99_ORO_RISCHIO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R99_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):
- `file prova al pin: 45 righe vive (42 parametri + 3 direttive @)`;
- `cella riletta nel file: 38 valori + 3 stringhe, rischio 1,00%, unico asse Y = InpMagic 779910/779911`;
- `COMPILATO ABTG_SupertrendReversal_Ottimizzato v1.00`;
- `ini in sosta: 8 su 8` (6 finestre + intera gemella + intera singola);
- **nessun PROBLEMA in elenco** e `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.**
> **`-SoloControllo` non apre MT5**, quindi **non esiste nessuno dei tre numeri
> firmati**: niente DD lungo, niente peggior giornata, niente DD di regime,
> niente `n`, niente data di prima operazione. Può confermare gli **artefatti**
> (file prova, cella, finestre, magic, `.ini`), **mai i numeri**. Sta scritto
> anche **dentro il suo referto**, perché nessuno lo scambi per il round
> (checklist 57).

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='46276278f7d293b954e355e5c09d432b96c5af50'; $p="$env:USERPROFILE\RIGA_R99.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R99_ORO_RISCHIO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R99_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella
> corsa vera `exit 1` può voler dire *"la corsa è riuscita e la risposta non ti
> piace"* (finestra accorciata, criterio B non misurabile, round parziale): gli
> artefatti **esistono** e vanno mandati lo stesso — un `throw` qui butterebbe
> via una risposta buona (checklist 26-bis). Nel **giro a vuoto** `exit 1` vuol
> dire una cosa sola: **non si lancia niente.**

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R99.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SENZAPASSO0`;
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri, è un referto
   **stantio**: si guarda il **nome della cartella** sul Desktop (porta data e
   ora) e si rifà.

---

## 🛠️ IL FATTO CHE COMANDA TUTTO IL DISEGNO

**`ABTG_SupertrendReversal_Ottimizzato` NON esporta il per-trade.** Verificato
nel sorgente al pin: l'unico `FileWrite` è quello di `OnTesterDeinit` (blocco
OPTFRAME), che scrive `OptResults_<EA>_<Simbolo>.csv` **e solo in
ottimizzazione**. Non esiste nessun `abtg_trades_*.csv` per questo EA.

Quindi i tre numeri firmati e i tre gate del PASSO 0 escono da **tre artefatti
diversi** — ed è la traduzione dichiarata nei criteri §5.2:

| serve | dove si legge |
|---|---|
| **A** DD lungo, **n**, **gemelli al centesimo** | `OptResults` di **due passate gemelle in ottimizzazione** sulla finestra intera (magic `779910`/`779911`), colonne `Equity DD %`, `Trades`, `Profit`, `Profit Factor` |
| **gate 1** prima operazione | **due misure indipendenti**, entrambe **sempre** eseguite (checklist 56-bis): il **log del tester** della passata singola (`InpVerbose=true` → `[STReversal] LONG mercato ...`, e la data simulata si prende scartando quella coi **millesimi**, che è l'orologio reale) **e** la **prima riga della tabella dei deal** del report `.htm` |
| **B** peggior giornata | **tabella dei deal** del report `.htm`: profitto sommato **per giorno**, diviso il **saldo a inizio giornata**. **[APPROSSIMATO]**: sulle chiusure realizzate, non sull'equity intraday — la stessa approssimazione di R51 |
| **C** DD nelle 4 finestre | **una coppia gemella per finestra**. È il metodo di casa: R50/R56/R59 hanno fatto esattamente così (celle × finestre) |

---

## 🛑 IL PASSO 0 DI R99 — cosa misura e cosa può fermare

### (a) 🔴 GATE 1 — la prima operazione, ed è **il** gate di questo round

| misura | esito | cosa fa la corsa |
|---|---|---|
| **≤ 2005.12.31** | ✅ finestra PIENA | prosegue |
| **fra il 2006 e il 2009** | 🟡 **FINESTRA ACCORCIATA** | **prosegue** e lo dichiara **accanto a ogni numero** (il criterio dice *"si dichiara accorciata"*, non *"ci si ferma"*) |
| **dopo il 2010.01.01** | 🔴 **FATALE** | **si ferma**: senza il 2008 e senza il 2013 la domanda del round non esiste più. ⚠️ Soglia **dichiarata come traduzione** nei criteri §5.1, **non** è una riga della firma |
| **non leggibile** | 🔴 **FATALE** | un gate che non legge niente **non è un gate verde** |

### (b) GATE 2 — `n` totale
*"si scrive, non si commenta"*. Viene dall'`OptResults`, **più** il controllo
incrociato coi deal del report: se i due `n` non coincidono, è un **PROBLEMA
scritto** (è la stessa cella su magic diversi: devono coincidere).

### (c) GATE 3 — i gemelli identici **al centesimo**
`Profit`, `Profit Factor`, `Equity DD %` e `Trades` delle due passate gemelle,
arrotondati a 2 decimali. Se divergono: **banco sporco, non si legge niente.**

---

## ⚖️ LA DECISIONE MECCANICA — e il buco che si vedrà nel referto

Il criterio firmato è: **se il DD lungo supera il DOPPIO del DD promesso in
`CONTRATTI_SEDIE.md`, la sedia va in REVISIONE** (corsia RISCHIO, firma 18/08).

🔴 **Il DD promesso di questa sedia NON È UN NUMERO.** Il suo contratto è
🟡 **PARZIALE**, e la cella dice testualmente *"PF 2,74 real-tick c'è, il DD NO:
a referto solo «basso», mai quantificato"*.

**Cosa fa la riga**, e perché così:
- **estrae** il DD promesso **dall'artefatto** (scarica `CONTRATTI_SEDIE.md` al
  pin), non dalla memoria di chi scrive;
- il parser è **deliberatamente stretto** e **rifiuta il `2,74`**, perché quel
  numero è il **PF** e non il DD: un regex largo l'avrebbe preso per
  denominatore e avrebbe prodotto **un verdetto firmato costruito su un numero
  sbagliato**;
- non trovando un numero, il referto scrive **`2x NON CALCOLABILE: contratto
  senza numero`** insieme alla **riga grezza** del contratto;
- ⚠️ **e dichiara che questo NON è un via libera**: una sedia viva sull'oro
  senza DD promesso **non ha nessun metro**, e la C3 del 18/08 su di lei non
  può scattare. È **esso stesso** un rilievo della corsia RISCHIO.
- 👉 I tre numeri che R99 misura sono **candidati a riempire** quel contratto.
  **Riempirlo è una firma nuova di Claudio**, non un esito automatico del round.

**Il criterio firmato non è stato toccato** (checklist 57: non si riapre un
documento firmato, e non si finge di eseguirlo — si **dichiara la traduzione**,
e la si scrive in **tre posti**: criteri §3.1, driver, referto).

---

## 📦 FILE ATTESI DI RITORNO

Sul Desktop: cartella e zip `R99_ORO_22ANNI_<MODO>_<data>_<ora>` (`MODO` =
`CORSA` / `CONTROLLO` / `SENZAPASSO0`). **È lo zip che si manda.**

| file | quanti | nota |
|---|---|---|
| `REFERTO_R99.txt` | 1 | riga `data:` di **adesso**, riga `modo:`; in testa i **tre numeri**, poi il confronto `2x`, poi i tre gate |
| `R99_XAUUSD_INTERA_ohlc.csv` | 1 | l'`OptResults` della finestra intera: **2 righe**, le gemelle. È da qui che esce il **CRITERIO A** |
| `R99_XAUUSD_{ORSO,CROLLO,TORO,LATERALE}_ohlc.csv` | 4 | il **CRITERIO C**, 2 righe l'uno |
| `R99_XAUUSD_{ORO2008,ORO2013}_ohlc.csv` | 2 | le **diagnostiche**: **non sono criteri** |
| `passo0_singola.ini` · `passo0_intera.ini` · `R99_<finestra>.ini` ×6 | 8 | la prova cartacea di **cosa** ha girato |
| `passo0_report_singola.htm` | 0 o 1 | il report della passata singola: è da qui che esce il **CRITERIO B**. Se manca, il referto lo dice e B resta **NON MISURATA** |
| `passo0_ingressi_log.txt` | 0 o 1 | le prime 40 righe d'ingresso lette nel log: la prova cartacea del **gate 1** |
| `passo0_intera_optresults.csv` | 1 | copia in sosta dell'`OptResults` intero |
| `passo0a_storico.csv` | 0 o 1 | il referto dello storico |
| `compile_r99.log` | 0 o 1 | c'è se MetaEditor ha scritto un log |

**Suffisso `_ohlc` su tutti i CSV**: è la regola di casa — un OHLC non deve
nemmeno **poter** finire nella stessa tabella di un tick reale.

---

## 🔎 COME SI LEGGE, IN ORDINE (è scritto anche dentro il referto)

1. **IL PASSO 0 PER PRIMO.** Se la **FINESTRA** è `ACCORCIATA`, quella riga va
   scritta **accanto a ogni numero**: il DD lungo non copre 22 anni. Se i
   **GEMELLI** divergono, non si legge niente.
2. **IL DD LUNGO (A) contro il DD PROMESSO.** È l'unica decisione del round ed è
   **meccanica**. Oggi: `2x NON CALCOLABILE` (§⚖️).
3. **LA PEGGIOR GIORNATA (B)** contro il muro prop giornaliero del **5%**.
4. **I QUATTRO DD DI REGIME (C).** Qui si guarda se **una finestra sola** fa il
   DD di tutta la storia: sarebbe il segno che il rischio è **concentrato in un
   regime** — e la flotta ha **12 grafici sull'oro**.
5. **LE DUE DIAGNOSTICHE 2008/2013**: si **dichiarano**. Non decidono niente.
6. **IL PROFITTO E IL PF NON SI USANO.** Emendamento **regola B**: il VECCHIO
   giudica il **RISCHIO**, il RECENTE giudica il **MERITO**. Sono nei CSV perché
   il CSV è quello che l'EA scrive, non perché entrino in un verdetto.
7. **R99 NON PROMUOVE E NON BOCCIA NIENTE.** Al massimo manda una sedia in
   **REVISIONE** sulla corsia RISCHIO, o **propone** di riempire un contratto
   parziale — e quella proposta **va firmata a parte**.
8. **E vale per UNA SEDIA SOLA.** Rifare la stessa misura sulle altre sedie oro
   è **un round nuovo**, non un corollario di questo.

---

## 🧾 LE SCELTE FATTE, DICHIARATE (e cosa è traduzione, non criterio)

**Prese dai criteri, senza margine:** simbolo `XAUUSD`, TF `H4`, finestra
`2004.06.11 → 2026.06.30`, **modello OHLC M1**, **rischio 1,00%**, la cella viva
congelata, i tre numeri, la decisione meccanica `2x`, le quattro finestre di
regime, i tre gate del PASSO 0, *"nessuna promozione, nessuna bocciatura di
merito"*.

| scelta | valore | perché |
|---|---|---|
| **niente `walkforward_generico.ps1`** | `.ini` scritti dal driver | quel driver spacca **sempre** in IS 40 / OOS 60, e il criterio A vuole il DD **su tutta** la finestra. Stesso schema del PASSO 0 di R98 |
| **`Deposit`** | **100.000** | i criteri non lo scrivono. È la taglia dei round per-trade (R16/R23) e a rischio percentuale il DD% è ~indipendente dal deposito (`CONTRATTI_SEDIE.md` §COME LEGGERE I NUMERI, punto 1). Su un deposito piccolo, con l'oro a 400 dollari nel 2004, il **lotto minimo** avrebbe schiacciato l'1% |
| **magic `7799xx`** | `779910/11` intera · `779912` singola · `779920..779971` finestre | il magic vivo è `970901` e c'è la **collisione `770901`** (censimento 22/08 §5). Il blocco `7799xx` è **vergine** in tutto il repo tranne `779001` (Guardian, che non trada). Le due fasi **non condividono il magic** (checklist 41) |
| **asse `Y` = `InpMagic`** | 2 celle per finestra | **non è uno sweep di strategia**: è la **coppia gemella di controllo**, cioè il gate 3 dei criteri. Nessun parametro di strategia viene spazzolato |
| **`InpVerbose=true`** | com'è nel sorgente | serve al **gate 1**: senza, la passata singola non stampa le righe d'ingresso. In **ottimizzazione** MT5 non esegue le `Print`, quindi sulle gemelle è **inerte** |
| **`InpUsaGuardian=true`** | com'è nel sorgente | nel tester è **fail-open totale** (le GlobalVariable del Guardian non esistono lì) e **il sorgente lo dichiara** alle righe 38-41. Non cambia una virgola del backtest |
| **2 finestre diagnostiche oro** | `2008.07.01-2008.12.31` e `2013.03.01-2013.06.30` | l'**ipotesi** nomina *"il crollo dell'ottobre 2008 e il crollo dell'aprile 2013"*, e **nessuna** delle quattro finestre di casa li contiene. Sono marcate **NON criteri** ovunque (criteri §8.1). ⚠️ **le date le ho scelte io** per contenere quegli eventi: non sono misurate su un criterio |
| **soglia fatale "dopo il 2010"** | traduzione | la firma dice *"si dichiara accorciata"* e non nomina nessun punto di rottura. Dichiarata nei criteri §5.1 |
| **verdetto M1 non-COMPLETO → NOTE** | non PROBLEMI | **misurato nel gemello**: `scarica_storico.ps1` scrive `InpTimeoutSec=120` nel preset — **due minuti per timeframe** — e 22 anni di M1 non ci stanno. Lasciarlo nei PROBLEMI voleva dire un `ESITO: PARZIALE` **garantito a ogni corsa sana**: è la spia che non può che essere rossa (checklist 47). Il tester completa da solo mentre gira |
| **`CROLLO_ANNO` non gira** | dichiarato | `prova_regime.ps1` ha **cinque** finestre: l'**Emendamento 2 del 15/08** sdoppia il crollo — *"CROLLO → il RISCHIO; CROLLO_ANNO → il MERITO"*. R99 è un round di **rischio**: usa il CROLLO da tre mesi. Scritto perché nessuno lo cerchi nel referto |
| **`-OreMax`** | **12** | 15 passate, di cui 3 su 22 anni di M1. È un tetto sull'**inizio** di nuove finestre |
| **`-SaltaPasso0`** | esiste, **sconsigliato** | serve solo a riprendere una coda già gatata. Se usato, il referto dichiara **in rosso** che i tre gate non sono stati eseguiti in quella corsa |

### 🧊 La cella: cosa è MISURATO e cosa resta [DA CONFERMARE]

**Misurato** (censimento `.chr` del 18/08 00:01, riga 38): magic **970901** =
default del sorgente ✅ · rischio **1** = il pin del criterio ✅ · commento
**`STREV OTT`** = default del sorgente ✅. **Tre indizi su tre coerenti.**

🟡 **[DA CONFERMARE]**: gli **altri 39 input non sono elencati in nessun
censimento** e sono presi dai **default del sorgente al pin** (che *sono* i
valori "OTT XAUUSD H4": `InpStMult=2.5`, `InpStAtrPeriod=7`, `InpTP_RR=2.5`,
scritti nei commenti del sorgente). Se sul VPS qualcuno ne ha toccato uno a
mano, **R99 misura il sorgente e non la sedia**. La conferma vera è leggere il
`.chr` del grafico `XAUUSDH41`. **Non è un prerequisito del lancio** — nessuno
dei 39 è mai stato dichiarato diverso — ma è scritto nel referto.
Nota nella stessa famiglia: i **lati** (`InpAllowLong`/`InpAllowShort`) sono già
classificati **[INCERTO]** per questa sedia in `prove/R52_CENSIMENTO_LATI.md`.

⚠️ **E la taglia**: fino al **17/08 23:34** questa sedia girava al **2,0%**
(`REFERTO_CENSIMENTO_RISCHIO.md`, che la elenca in rosso fra le tre al doppio);
il rischio è stato abbassato a 1 la notte stessa. **Se tornasse al 2%, tutti i
numeri di R99 vanno raddoppiati** — scalatura lineare, **[APPROSSIMATA]**,
convenzione di `CONTRATTI_SEDIE.md`.

---

## 🔎 QUELLO CHE IO **NON** HO POTUTO VERIFICARE — per il verificatore

Nessuno di questi è un difetto noto: sono **buchi di verifica dichiarati**.
Vanno chiusi **prima** che la riga arrivi a Claudio.

1. ✅ **CHIUSO — IL `.ps1` È STATO PARSATO.** Il verificatore ha installato
   **PowerShell 7.4.6** e ha eseguito
   `[System.Management.Automation.Language.Parser]::ParseFile` sul driver:
   **0 errori di sintassi** (13.481 token), rifatto **dopo** la correzione.
   Controlli statici passati: **ASCII puro** (`grep -P '[^\x00-\x7F]'` = 0),
   **nessun formato .NET invalido** (le sei `-f` usano solo allineamenti validi
   `{n,-10}` / `{n,8}`), **nessun `TryParse`/`::Parse`/`ToString` senza
   `InvariantCulture`**. I parser del round sono stati **eseguiti a cultura
   `it-IT` attiva** (dove `(2.5).ToString()` dà `2,5`): `NumInv` legge
   `2.7400` → `2,74` e **rifiuta** `2,74`; `DataSimulata` scarta la data coi
   millesimi e prende quella simulata; `Fmt2` dà `n/d` sui negativi. I gate del
   file prova e **le due fabbriche di `.ini`** sono stati fatti girare
   sull'artefatto vero **con CRLF**: 45 righe vive, 42 parametri, 38 valori di
   cella tutti trovati (le `\r?` reggono), unico asse `Y` = `InpMagic`,
   **8 `.ini` su 8** coi magic `779910…779971`.
   🔴 **E il parse non ha trovato il difetto: l'ha trovato la prova.** Vedi
   §STATO — `LeggiDeal` leggeva le colonne per posizione. **Corretto.**
2. 🟡 **IL REPORT `.htm` È [INFERITO], NON MISURATO.** Che MT5 scriva la tabella
   dei **deal** in un report generato via `/config` con `Report=` +
   `ReplaceReport=1`, e **dove** lo scriva, **non l'ho verificato su questa
   macchina**: in tutto il repo nessuno script ha mai letto un report del
   tester. Lo script lo **cerca in quattro radici** e, se non lo trova o non ne
   riconosce le righe, **scrive `PEGGIOR GIORNATA: NON MISURATA`** con le
   istruzioni per averla a mano — **e non inventa nessun numero**. 👉
   **Conseguenza da mettere in conto**: se salta, il round torna con **A e C
   misurati e B mancante**, e il gate 1 resta in piedi grazie alla misura sul
   log. **Non è un motivo per non lanciare**, è un motivo per non stupirsi.
   ✅ **Rinforzato dal verificatore**: il "non inventa nessun numero" adesso è
   **vero anche quando il report c'è ma è fatto diversamente**. Provato su
   quattro layout finti — senza colonna commento, **con** colonna commento,
   **intestazione italiana**, intestazione irriconoscibile: `-3,52%` nei primi
   tre, **`NON MISURATA`** nel quarto. Prima della correzione i casi 2 e 3
   davano **`0,00%`**.
3. 🟡 **La durata è una [STIMA] pura**: nessuno in casa ha mai girato 22 anni di
   OHLC M1 su questo simbolo. Il PASSO 0 **misura** la prima passata e stampa la
   proiezione: se la singola dovesse metterci più di un'ora, conviene fermarsi e
   ripensare la scala **prima** delle finestre.
4. 🟡 **`InpNewsCurrencies=` (stringa vuota) viene scritta esplicitamente**
   nell'`.ini`. `walkforward_generico.ps1` in quel caso **salta la riga** e
   lascia il default compilato; io la scrivo, perché un input **non nominato**
   resta all'ultimo valore che MT5 ricorda (checklist 25). È inerte
   (`InpUseNewsFilter=false`), ma è una **differenza dichiarata** rispetto al
   gemello. ⚠️ E **il giro a vuoto non la può collaudare**, perché non apre MT5:
   se MT5 rifiutasse la riga vuota, lo si vedrebbe **solo alla prima passata**.
   👉 Se il PASSO 0 non produce niente, **è la prima cosa da guardare**: si
   toglie quella riga dal file prova e si rifà il giro dal verificatore.
5. 🟢 **Il conteggio "38 valori" del giro a vuoto** è una **costante** dello
   script (`$Cella`), non un conteggio sull'artefatto: se un default del
   sorgente cambiasse, il gate **si ferma** (non è un verde falso), ma il
   messaggio parlerebbe del file prova invece che del sorgente. Ricontato a mano
   su questo pin: **38 + 3 stringhe + `InpMagic` = 42** ✔.
