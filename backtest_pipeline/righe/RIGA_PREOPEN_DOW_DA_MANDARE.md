# 📬 PREOPEN DOW — il livello **pre-apertura** — **LA RIGA DA MANDARE**

---

# 🛑 PRIMA DI LANCIARE: LEGGI I CRITERI. NON È UN CONTA-OPERAZIONI.

> ## ⚠️ QUESTO ROUND HA **CRITERI DI MERITO GIÀ CONGELATI**.
>
> Gli ultimi tre giri preparati oggi (**G1PAOLO**, **VWAPREV**, **FVGRET**)
> erano **conta-operazioni**: si lanciavano, si guardava un numero, fine.
> **Questo no.** Questo produce un **VERDETTO** — `PASSA` / `NON PASSA` /
> `MERITO SOSPESO` — e quel verdetto **entra agli atti**.
>
> Il file prova porta in testa il cartello:
> **_«QUESTO FILE NON DEVE GIRARE FINCHÉ I CRITERI NON SONO FIRMATI»_**.
>
> ### 👉 Prima di incollare qualunque riga, **apri e leggi**
> ### 📄 `backtest_pipeline/prove/PREOPEN_RETEST_DOW_M15.txt`
> ### e in particolare **due sezioni**:
>
> | sezione | perché non si salta |
> |---|---|
> | **`COME PUÒ MORIRE`** | dice **in anticipo** i tre modi in cui questo round può bocciare il candidato: frequenza troppo bassa, la lezione esterna che gioca **contro** (arXiv 2605.04004: il retest su livello giovane prende il *fallimento* della rottura, non la continuazione), e il **doppione mascherato** con `ABTG_MaxMinNotte`. Se non li hai letti prima, quando escono li leggerai come "sfortuna" invece che come **la risposta che avevamo chiesto** |
> | **`CRITERI DI ACCETTAZIONE`** | dice **cosa vuol dire PASSA**: una regione di **≥3 celle adiacenti** in OOS con Profit>0, PF≥1,10, n≥30, DD<8%, peggior giornata >−2,0%, **e** che batta il **metro** di almeno **+0,10 di PF**. Più il **PASSO 0** in tre pezzi, che viene **prima di qualunque PF** |
>
> ### ✍️ E ci sono **TRE decisioni** che ho preso io per rendere i criteri **eseguibili**, e che tu devi vedere e approvare **prima**, non dopo: sono nel riquadro **[LE TRE INTERPRETAZIONI]** più sotto.
>
> **Se non hai letto quelle due sezioni, non lanciare.** Il round costa
> un'ora di macchina; rileggere il file prova costa cinque minuti, e senza
> quei cinque minuti il risultato non è interpretabile.

---

## 🧭 Che cos'è, in una riga

Il nostro **`ABTG_Dow_Apertura_US`** — la **sedia viva del Dow** — ha un
interruttore che **non abbiamo mai acceso**: `InpRangeMode=1`, che costruisce
il livello dal **range PRE-apertura** invece che dai primi 35 minuti dopo.
Questo round **lo accende e lo misura**. 🔧 **Zero codice EA scritto:
l'interruttore c'è dal primo giorno** (`ComputeLevels`, ramo `ABTG_RANGE_PREV`).

**Misurato nel repo il 28/08:** su 48 file prova, **47 pinnano `InpRangeMode` a
0** e `InpPrevWindowMin` è pinnato a **60 in 28 file su 28** — **mai mosso**.
È un pezzo di macchina **pagato e mai usato**.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_Dow_Apertura_US.mq5` — **la sedia viva**, magic `770202`, **non si tocca** |
| **Driver** | `backtest_pipeline/righe/RIGA_PREOPEN_DOW.ps1` (marcatore `MARCATORE_RIGA_PREOPEN_DOW_v2`) |
| **File prova** | `prove/PREOPEN_RETEST_DOW_M15.txt` (**i criteri**) · `_SHORT.txt` · `PREOPEN_METRO_DOW_M15.txt` · `PREOPEN_METRO_DOW_M15_SHORT.txt` · `PREOPEN_COSTO_DOW_M15.txt` |
| **Origine** | caccia intraday indici del 28/08, §2, candidato **P1 "Tristan's Box"** |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_PREOPEN_DOW.md` |

---

## 🔬 CHE COSA GIRA, IN ORDINE — e l'ordine **non è negoziabile**

| # | fase | che cos'è | passate |
|---|---|---|---|
| **1** | 🚧 **COSTO** (PASSO 0b) | **una passata SINGOLA** sulla cella **centro** della griglia → report `.htm` → **mediana del take LORDO in punti indice**. 🔴 **Se FALLISCE, il round si ferma qui e non viene letto NESSUN Profit Factor** | 1 |
| **2** | 📏 **METRO** (PASSO 0c) | la **cella viva** (`InpRangeMode=0`) rifatta **su M15**, sui **due lati**. È il **denominatore** del `+0,10 di PF` | 24 |
| **3** | 🔲 **GRIGLIA** | `InpPrevWindowMin` (60→300) × `InpRetestOffsetPts` (200→600), sui **due lati** | 120 |
| **4** | 🔢 **0a + criteri** | si contano le operazioni (**valvola R59**), poi il codice applica i criteri **cella per cella** e stampa il numero accanto a ognuno | — |

**≈145 passate a tick reali.** ⏱️ **[STIMA, non una previsione]: 50-120 minuti**
più la compilazione. R107 fece 24 passate sulla stessa finestra in 9 minuti.

---

## ✍️ [LE TRE INTERPRETAZIONI] — le decisioni che ho preso io, da approvare

I criteri firmati lasciano **tre buchi** che un codice deve per forza riempire.
Li ho riempiti così, **prima di vedere qualunque numero**, e li scrivo qui
perché tu possa **cambiarli adesso** invece che discuterli dopo.

### 1️⃣ Il cancello del costo ha **TRE stati**, non due

Il file prova dice *«take mediano ≥ 6,0 punti indice. Sotto, il round si ferma
qui»*, e cita **METRO_PROP D4**. Ma **D4 è proprio la regola che vieta il
verdetto secco**, perché lo **spread non è misurato** (è **dichiarato** 2,0
punti indice). Quindi, come in **R109**:

| take **lordo** mediano | stato | cosa fa il round |
|---|---|---|
| **> 7,0** punti indice (>3,5× lo spread) | ✅ **SUPERATO** | prosegue |
| **5,0 – 7,0** (2,5×–3,5×) | 🟡 **SOSPESO** | **prosegue**, ma ogni numero esce col cappello *«il costo non è dimostrato sopra la soglia»* |
| **< 5,0** (<2,5×) | 🔴 **FALLITO** | 🛑 **si ferma**, e nessuna griglia viene letta |

> ⚠️ **Conseguenza da vedere adesso:** un take **esattamente a 6,0** esce
> **SOSPESO**, non SUPERATO. È voluto: *dare un verdetto secco su un numero
> dentro l'incertezza del suo metro è il modo più elegante di sbagliare.*
> **Se preferisci il confronto secco a 6,0, dimmelo e lo cambio in due righe.**

| take LORDO | criterio FIRMATO | driver |
|---|---|---|
| 4,0 | si ferma | 🔴 FALLITO → si ferma |
| 5,0–5,99 | si ferma | 🟡 SOSPESO → PROSEGUE |
| 6,0–7,0 | passa | 🟡 SOSPESO → prosegue |
| 7,01+ | passa | ✅ SUPERATO |

> 🔴 **La conseguenza da vedere per prima:** nella banda **5,0–6,0** il criterio
> **FIRMATO** direbbe *«il round si ferma qui»* e io **PROSEGUO** (col cappello).
> È **l'unico punto** in cui la mia interpretazione **allarga** un cancello
> congelato: va approvato o negato adesso, non dopo aver visto il numero.

### 2️⃣ Con le **parziali accese**, «il take» non è un numero solo

Questa sedia ha `InpTP1_ClosePct=50` e il breakeven al primo obiettivo: **una
posizione produce più di un'uscita**. (R109 misurava un motore *senza*
parziali e poteva pretendere volumi uguali fra `in` e `out`; qui quella regola
boccerebbe un motore sano.)

- **take per GAMBA** = `|prezzo_out − prezzo_in|` di **ogni** uscita in
  guadagno → **è la più CONSERVATIVA** (la prima parziale è la più corta, ed è
  quella più esposta al costo) → **è questa che fa il verdetto**;
- **take per POSIZIONE** = media **pesata sui volumi** → **informativa**, e il
  referto **la stampa accanto**, sempre.

👉 Così, se il round si fermasse per il costo, **si vede subito** se si è
fermato **per il motore** o **per la definizione**.

### 3️⃣ Il criterio cerca la regione **dentro l'OOS**: è uno **SCREENING**

Il criterio firmato dice *«PASSA se, **in OOS**, esiste una regione…»*. Preso
alla lettera, **la regione si trova guardando il fuori campione** — che **non
è** una selezione walk-forward. Il codice **applica il criterio firmato così
com'è** (non lo cambio da solo), **e in più** stampa la lettura onesta: *«la
cella che l'IS avrebbe scelto, e come si è comportata in OOS»*. Le due righe
stanno una sotto l'altra nel referto.

---

## 🔐 I MAGIC — tutti **vergini**, la sedia viva **vietata**

| file | magic gemelli |
|---|---|
| griglia **LONG** | `773500` / `773501` |
| griglia **SHORT** | `773600` / `773601` |
| metro **LONG** | `773700` / `773701` |
| metro **SHORT** | `773800` / `773801` |
| **cancello del costo** | `773900` / `773901` |

Tutti **verificati con grep su tutto il repo il 28/08** (`.git` escluso):
`7737xx`, `7738xx`, `7739xx` → **zero occorrenze**; `7735xx`/`7736xx`
compaiono **solo** nelle righe che li **dichiarano**.

🔴 **`770202` — il magic VIVO di questa sedia — è nella lista dei VIETATI**: se
comparisse in un file prova il driver **si ferma prima di aprire MT5**, perché
il tester non deve poter incrociare i deal del forward.

🔴 **Il cancello ha un magic TUTTO SUO** e non è un vezzo: l'export per-trade
dell'EA porta il **magic nel nome del file**, quindi una griglia che
condividesse il magic **cancellerebbe la prova del gate** (CHECKLIST 41).

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare: `walkforward_generico.ps1` **non lo fa**, e senza quel file l'EA
  non compila.
- 🔨 **Il giro a vuoto COMPILA DAVVERO**, e cancella l'`.ex5` prima. Sì, l'EA è
  già vivo in produzione e un `.ex5` c'è quasi sicuramente — **è proprio per
  questo**: un `.ex5` **vecchio** sotto un `.mq5` **nuovo** non è un no-op, è un
  binario che **opera mentendo sulla versione** (CHECKLIST 54).
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini, `AllowLiveTrading=false`
  in **tutti** gli `.ini` (compreso quello della passata singola, che scrive
  questa riga: aprire MT5 *per misurare* riarmerebbe la flotta — CHECKLIST 51).
- **Banco:** `Model=4` (**tick reali**), finestra **2024.09.26 → 2026.06.30**,
  split 40/60 (**IS** fino al `2025.06.09`, **OOS** dal `2025.06.10` — le stesse
  di R101), deposito **100.000**, rischio **1%**, `Spread=0` **scritto
  nell'ini** (= spread corrente, **dichiarato**, come R101).
- 📐 **Il DD si legge ×0,65** per portarlo alla taglia prop 100k (in campo il
  rischio è 0,65%). Il referto stampa **tutti e due** i numeri.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.

---

## 📌 IL PIN — **`89f9d148d7784f0dbfcc44ddfa4feb6711864e7b`**

```
89f9d148d7784f0dbfcc44ddfa4feb6711864e7b
```

✅ **Pin VERIFICATO il 28/08**: commit esistente su `origin/lavoro`, e i **nove**
artefatti che lo script scarica (`walkforward_generico.ps1`, `RIGA_PREOPEN_DOW.ps1`,
i cinque file prova, `ABTG_PausaGuardian.mqh`, `ABTG_Dow_Apertura_US.mq5`) hanno a
quel commit lo **stesso contenuto** che hanno adesso sul branch.
_(Storia: prima della pinnatura qui c'era un segnaposto; il cartello che lo diceva
è stato tolto nello stesso passo in cui il pin è diventato vero.)_

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e otto** gli artefatti che lo script scarica:
`walkforward_generico.ps1`, `RIGA_PREOPEN_DOW.ps1`, i **cinque** file prova,
`ABTG_PausaGuardian.mqh` e **`ABTG_Dow_Apertura_US.mq5`**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_PREOPEN_DOW_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9A-Za-z]{40}'" "$F" | head -1 | grep -oE "[0-9A-Za-z]{40}")
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Servono TUTTI E DUE i conteggi**: il solo *«0 pin vecchi rimasti»* lo
supera a mani basse anche un `sed` che **non ha matchato niente**.

⚠️ **E il pin vecchio si legge DAI PUNTI D'USO** (`$pin='<40 caratteri>'`), mai
con un `grep` largo: se un giorno questa pagina avrà una riga di storia del
tipo *«il pin X è BRUCIATO»*, un `sed` largo **riscriverebbe la storia**.

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata di misura; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='89f9d148d7784f0dbfcc44ddfa4feb6711864e7b'; $p="$env:USERPROFILE\RIGA_PREOPEN_DOW.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DOW.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DOW_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine:

- `pin ......... <40 caratteri>` · `fasi ........ COSTO -> METRO -> GRIGLIA (tutte)`;
- `IS ....... 2024.09.26 - 2025.06.09` e `OOS ...... 2025.06.10 - 2026.06.30`
  — **le stesse di R101**: se fossero diverse, il metro non sarebbe
  confrontabile e il driver lo scrive nei RILIEVI;
- `file prova scaricati: 5`;
- `assi letti nel file prova: InpPrevWindowMin 5 valori, InpRetestOffsetPts 3
  valori -> 15 celle x 2 gemelli = 30 passate per finestra e per lato`
  — **contati sul file prova, non a memoria**;
- `geometria, lati, RangeMode, baseline, stella, magic e assi: TUTTI PASSATI
  (cella del cancello: PrevWindowMin=180, RetestOffsetPts=400, magic 773900)`;
- `terminale scelto: ...` → deve contenere **`BCM Markets MT5 Terminal`** e
  **non** contenere `-V3`. È **lo stesso selettore, riga per riga**, di
  `walkforward_generico.ps1`;
- `include: INSTALLATO e VERIFICATO in ...`;
- **`compilato ABTG_Dow_Apertura_US: OK (<n> KB, <ora>)`**;
- `ini della passata singola scritto e verificato: ...` — l'`.ini` del cancello
  è **costruito e passato per tutti i suoi gate** anche a vuoto;
- `NON ESEGUITO (giro a vuoto: l'ini c'e' ed e' passato tutti i gate, MT5 non
  e' stato aperto)`;
- quattro volte l'anteprima dell'`.ini` del driver generico, e in fondo
  `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun controllo sui
> gemelli**, e **il cancello del costo non è stato eseguito**. Conferma gli
> **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='89f9d148d7784f0dbfcc44ddfa4feb6711864e7b'; $p="$env:USERPROFILE\RIGA_PREOPEN_DOW.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DOW.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DOW_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Tre righe staccate
sarebbero tre comandi indipendenti, e un `throw` alla prima non fermerebbe le
altre.

### 🔁 Se serve riprendere una fase sola

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='89f9d148d7784f0dbfcc44ddfa4feb6711864e7b'; $p="$env:USERPROFILE\RIGA_PREOPEN_DOW.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DOW.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DOW_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloFase 'GRIGLIA' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - normale su una ripresa: lo zip esiste, mandalo' -ForegroundColor Yellow } }
```

Fasi valide: **`COSTO`** · **`METRO`** · **`GRIGLIA`**.

> 🔴 **UNA RIPRESA NON DÀ MAI UN VERDETTO DEFINITIVO, ed è voluto.** I CSV
> delle fasi non rilanciate vengono **letti da disco** e **marcati
> `DA DISCO <data>`**: il pin con cui furono prodotti non è agli atti di quel
> referto. In quel caso il referto stampa in chiaro *«NESSUNO DEI VERDETTI QUI
> SOPRA È DEFINITIVO»* e **l'uscita è 1 anche se è andato tutto bene**.

---

## 🔢 IL CODICE D'USCITA HA UN SIGNIFICATO SOLO

| codice | vuol dire |
|---|---|
| **0** | un round **COMPLETO**, in **UN LANCIO SOLO**, **senza problemi** |
| **1** | **tutto il resto**: fermato, problemi, riprese, `-SoloFase`, dati da disco |

Così uno **0** non può **mai** voler dire *«ho letto mezzo round e ho dato un
verdetto»*. 📌 **Misurato eseguendo il driver il 28/08:** prima di questa
regola un errore fuori dai `try` faceva uscire lo script **con codice 0** —
cioè il caso peggiore, una corsa esplosa che si presenta come riuscita. Adesso
c'è un `trap` che garantisce **1** su qualunque uscita anomala.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PREOPEN_DOW_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PREOPEN_DOW.txt`** ← **è questo che conta**;
- i **cinque file prova** (così il referto porta con sé i criteri con cui è stato giudicato);
- gli **8 CSV** `ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_{metro_long,metro_short,griglia_long,griglia_short}.csv`;
- **`gen_preopen_costo.ini`** e **`REPORT_COSTO.htm`** (la prova del cancello);
- `COMPILAZIONE_FALLITA.log`, **se** la compilazione fallisce.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

E se in cima trovi il riquadro **`QUESTA CORSA È STATA FERMATA. IL REFERTO È
MONCO.`**, tutto quello che segue è **quello che era stato misurato fino a quel
punto**: non è un verdetto.

---

## 🚩 COME SI LEGGE IL REFERTO — quattro avvertenze, non quattro note

1. 🚧 **Il cancello del costo viene PRIMA.** Se dice `FALLITO`, nel referto
   **non c'è nessuna griglia**, ed è giusto così: *un motore che non copre il
   proprio costo non ha bisogno di una griglia per essere bocciato*.
2. 📏 **Il metro su M15 potrebbe non riprodurre i numeri di R101** (che sono su
   **M5**: OOS +6.722 · PF 1,270 · DD 4,39% · n 130). **Non è un gate ed è
   un'attesa dichiarata**: se esce vicino, il timeframe su questo motore è
   quasi neutro; se esce lontano, il timeframe conta — **ed è esattamente
   perché il metro 0c è stato preteso**. In tutti e due i casi **il metro del
   round è il numero misurato ADESSO su M15**, non quello di R101.
3. 📉 **Il lato SHORT parte svantaggiato PER REGIME, non per demerito.** Il
   filtro EMA è acceso e in `MonitorRetest` lo short passa solo con `gBias` 0 o
   −1: in 21 mesi di Dow sopra la sua EMA H4, **lo short quasi non entra**. Un
   `n` basso è **atteso**, e sotto 30 scatta la **valvola R59**: niente
   verdetto di **MERITO**, ma il **RISCHIO si giudica lo stesso** — un
   drawdown è **un fatto accaduto**.
4. 🎚️ **Guarda la riga dei VOLUMI del cancello.** Se i valori distinti sono
   **1** e il volume è il minimo del broker, il lotto è andato a sbattere sul
   **pavimento `VOLUME_MIN`** (in `CalcLotByRisk` c'è un `MathMax(minLot,…)`):
   in quel caso **il rischio vero per operazione è più alto dell'1% dichiarato
   e i DD del round sottostimano**. Sui **bordi larghi** della griglia
   (`PrevWindowMin=300` → stop più largo → lotto più piccolo) questo
   **NON è misurato**: è un `[DA VERIFICARE]` dichiarato, non un risultato.
5. ⏱️ **Il confronto col metro porta un confondimento di 35 MINUTI, misurato
   nel sorgente** (`ABTG_Dow_Apertura_US.mq5`, righe 656-684): il candidato
   arma alle **14:30 server** (`InpRangeMode=1`), il metro alle **15:05**
   (`InpRangeMode=0`, `InpRangeMinutes=35`) — finestra **3h00 contro 2h25**,
   **+24%**. Un vantaggio del candidato sul metro è **in parte tempo, non
   livello**: il referto lo stampa accanto a ogni verdetto `PASSA`.

---

## 🚫 QUELLO CHE QUESTO ROUND **NON** DICE

- ❌ **Un round che PASSA produce una CELLA CANDIDATA, non una sedia.** La
  promozione in forward è **un'altra decisione, con un'altra firma**.
- ❌ **Il doppione mascherato NON è misurato qui.** Se le celle vincenti
  coincidessero **giorno per giorno** con quelle di `ABTG_MaxMinNotte`, il
  candidato va **scartato per correlazione** (ROTTA_PROP regola 1), **non
  promosso**. Quella misura vuole la **sovrapposizione delle giornate**, non i
  PF: si fa **dopo**, e **solo se** il round passa.
- ❌ **Il gemello DAX è il passo SUCCESSIVO, non questo.** E lì il rischio di
  doppione con `ABTG_MaxMinNotte_DAX_Short` è **alto**, perché con
  `PrevWindowMin` grande la finestra pre-apertura **cade dentro la notte
  asiatica**.
- ❌ **Lo spread non è misurato**: è **dichiarato** 2,0 punti indice (lato alto
  della forchetta 1-2 di `R98_CRITERI`). Ogni verdetto del cancello esce con
  l'etichetta `[SPREAD NON MISURATO]`.
- ❌ **Un backtest profittevole non è un profitto live.** Broker singolo,
  costi di un feed solo, **un solo regime** (21 mesi rialzisti).
