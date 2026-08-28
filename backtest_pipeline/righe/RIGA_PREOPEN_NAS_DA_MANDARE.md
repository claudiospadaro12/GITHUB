# 📬 PREOPEN NAS — il livello **pre-apertura** sul Nasdaq — **LA RIGA DA MANDARE**

---

# 🛑 LEGGI QUESTO PRIMA DI TUTTO: **QUESTA SEDIA È SPENTA**

> ## ⚰️ `ABTG_Nasdaq_Apertura_US` (magic `770201`) è **SPENTA dal 18/08/2026 alle 09:41**
>
> FIRMA 5 — *«SPEGNILE TUTTE E TRE»* — verbale in `report/FIRME_2026-08-18.md`
> e `report/PIANO_PROP.md` v8-v9. È **l'unica sedia che il censimento marca
> 🔴 SENZA CONTRATTO** (`report/CONTRATTI_SEDIE.md` riga 45).
>
> ### E ha **QUATTRO verdetti negativi indipendenti** agli atti:
>
> | # | quando | cosa dice |
> |---|---|---|
> | 1 | **31/07** | tick reali: **PF 0,82 · DD 17% · SCARTATO** |
> | 2 | **05/08** | walk-forward: **19 celle OOS negative su 20** |
> | 3 | **18-19/08** (R83+R84) | **12 configurazioni, 12 OOS negative** — *«terzo verdetto indipendente sulla 770201»* |
> | 4 | **25/08** (R107) | la geometria **viva del Dow** trasposta qui: long PF **1,110** · short PF **0,460** → *«la geometria del Dow NON SI TRASPORTA sul Nasdaq»* |
>
> ## 🎯 Conseguenza sul SIGNIFICATO del round — da leggere prima dei numeri
>
> **Questo NON è un round che rimette in campo una sedia. È UNA PORTA CHE SI
> CHIUDE CON UN NUMERO.** L'unico ingrediente della famiglia «apertura Nasdaq»
> che non abbiamo **mai** provato è l'interruttore `InpRangeMode=1`; se non paga
> nemmeno lui, la porta si chiude con **quattro verdetti più uno** — e quel
> «più uno» **è il valore del round**.
>
> Un risultato **positivo** qui **non riaccende niente da solo**: produce una
> **CELLA CANDIDATA** che, per tornare in campo, deve passare dalla **porta di
> rientro del criterio C3** (*«una sedia spenta rientra se una misura nuova le
> ridà una ragione»*) — **altra decisione, altra firma**.
>
> 🧊 **E un `PASSA` qui va guardato con SOSPETTO prima che con entusiasmo:** con
> quattro bocciature alle spalle, la prima cosa da cercare non è l'edge, è il
> **difetto di misura**. Il referto lo scrive da solo, in fondo, come cappello
> n. 4 del verdetto.

---

## 🛑 E POI: LEGGI I CRITERI. NON È UN CONTA-OPERAZIONI.

> ### 👉 Prima di incollare qualunque riga, **apri e leggi**
> ### 📄 `backtest_pipeline/prove/PREOPEN_RETEST_NAS_M15.txt`
> ### e in particolare **`COME PUÒ MORIRE`** e **`CRITERI DI ACCETTAZIONE`**.
>
> I criteri sono **PRESI PARI PARI dal round Dow**, non rigiudicati da zero: i
> tre round PREOPEN (Dow · DAX · Nasdaq) sono una **famiglia**, e criteri
> diversi per i tre gemelli renderebbero i tre verdetti non confrontabili.

---

## 🧭 Che cos'è, in una riga

`ABTG_Nasdaq_Apertura_US` ha un interruttore che **non abbiamo mai acceso**:
`InpRangeMode=1`, che costruisce il livello dal **range PRE-apertura** invece che
dai primi 35 minuti dopo. Questo round **lo accende e lo misura**.
🔧 **Zero codice EA scritto**: l'interruttore c'è dal primo giorno
(`ComputeLevels`, righe 869-872, ramo `ABTG_RANGE_PREV`).

**Misurato con grep su `prove/` il 28/08:** sul Nasdaq `InpRangeMode` è sempre
pinnato a **0** oppure a **2** (il default compilato è **2**, cioè la candela H1
precedente). **Mai 1.**

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` — sedia **SPENTA**, magic `770201`, **vietato lo stesso** |
| **Driver** | `backtest_pipeline/righe/RIGA_PREOPEN_NAS.ps1` (marcatore `MARCATORE_RIGA_PREOPEN_NAS_v1`) |
| **File prova** | `prove/PREOPEN_RETEST_NAS_M15.txt` (**i criteri**) · `_SHORT.txt` · `PREOPEN_RIF_NAS_M15.txt` · `PREOPEN_RIF_NAS_M15_SHORT.txt` · `PREOPEN_COSTO_NAS_M15.txt` |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_PREOPEN_DAX_NAS.md` |
| **Gemelli di famiglia** | 🇺🇸 **Dow** = `RIGA_PREOPEN_DOW.ps1` (girato stamattina) · 🇩🇪 **DAX** = `RIGA_PREOPEN_DAX.ps1` (preparato oggi insieme a questo) |

---

## 📏 «RIF», NON «METRO» — e la differenza **non è una sfumatura**

Sul Dow e sul DAX il file gemello si chiama **`METRO`** perché lì la sedia è
**viva** e i numeri agli atti esistono: quella cella **riproduce** un numero, e
quindi fa anche da **gate G0** («il banco è sano»).

**Qui no.** Non esiste nessuna sedia viva con questa geometria, quindi:

- il file si chiama **`PREOPEN_RIF_NAS_M15.txt`**, la fase si chiama **`RIF`**,
  e nel referto la parola è **RIFERIMENTO**;
- 🔴 **IN QUESTO ROUND NON C'È NESSUN GATE G0.** Dalle righe del riferimento
  **non si può concludere che il banco sia sano**;
- serve a **una cosa sola**: dare un **denominatore** alla griglia, così che
  «PF 1,05» si sappia se è un giudizio sul **LIVELLO** o sulla **GEOMETRIA
  TRASPOSTA**.

> 📌 È la stessa scelta, con le stesse parole, di `R107_NAS_00_riflong`. Se un
> domani questo file venisse rinominato `METRO` per simmetria, il round
> comincerebbe a **promettere un gate che non ha**.

**Da dove viene la geometria** (e il suo limite, dichiarato prima dei numeri):
è **quella viva del DOW, trasposta di peso** su NASUSD — stessa ora, stesso
range 35', stesso `EntryMode=2` (RETEST), stesso buffer 1000, stesso offset 400,
stesso EMA H4, stesso pavimento stop 500, stessa chiusura 17:30, stesso rischio.

> ⚠️ **La trasposizione è una SCELTA, non una neutralità:** buffer e offset sono
> in **punti assoluti** e i due indici non hanno la stessa scala. 1000 punti =
> 10 punti indice: su un Dow a ~44.000 sono lo **0,023%**, su un Nasdaq a
> ~20.000 sono lo **0,05%** — **il doppio** in termini relativi. Qualunque
> riscalatura sarebbe un parametro nuovo deciso a tavolino: **l'inizio della
> pesca**.
> 👉 **Conseguenza che il referto DEVE scrivere:** se le celle escono rosse, il
> risultato è **«il livello pre-apertura non salva la geometria trasposta sul
> Nasdaq»**, NON «il Nasdaq non ha edge in apertura». Sono due frasi diverse e
> **solo la prima è misurata**.

---

## 🚨 LA TRAPPOLA DI CORRELAZIONE COL GEMELLO DOW — il rischio più concreto

Il candidato **Dow** di questa stessa famiglia:

- arma alla **STESSA ORA** (14:30 server);
- col **MECCANISMO IDENTICO** (`RangeMode=1` + retest);
- sugli **STESSI valori dell'asse** (`PrevWindowMin` 60→300 = **le stesse
  finestre d'orologio**);
- su un indice che **nella stessa mezz'ora si muove insieme** a questo.

`ROTTA_PROP` regola 1 vieta due EA sullo stesso segnale: qui il **simbolo** è
diverso ma **il segnale è lo stesso**. 🔴 **E il drawdown della prop è UNO.**

> **Se passassero tutti e due, NON si promuovono insieme** prima di aver
> misurato la **sovrapposizione delle GIORNATE** fra le due celle.
> **Passo successivo dichiarato, non fatto qui:** due passate singole (cella Dow
> e cella Nasdaq, **magic vergini distinti**) sulla stessa finestra, i due export
> per-trade `abtg_trades_<EA>_<simbolo>_<magic>.csv` in `Common\Files`, e il
> conto delle giornate in comune.
> ⚠️ **Nota di onestà:** `sovrapposizione_sedie.py` **non serve** a questo —
> legge gli statement del **forward**, non i per-trade di un backtest. Quel
> pezzo di codice **va scritto**.

---

## 🔬 CHE COSA GIRA, IN ORDINE — e l'ordine **non è negoziabile**

| # | fase | che cos'è | passate |
|---|---|---|---|
| **1** | 🚧 **COSTO** (PASSO 0b) | **una passata SINGOLA** sulla cella **centro** della griglia → report `.htm` → **mediana del take LORDO in punti indice**. 🔴 **Se FALLISCE, il round si ferma qui e non viene letto NESSUN Profit Factor** | 1 |
| **2** | 📐 **RIF** (PASSO 0c) | la cella di **riferimento** (`InpRangeMode=0`, la geometria di `R107_NAS_00_riflong`) rifatta **su M15**, sui **due lati**. È il **denominatore** del `+0,10 di PF` — **non un gate G0** | 24 |
| **3** | 🔲 **GRIGLIA** | `InpPrevWindowMin` (60→300) × `InpRetestOffsetPts` (200→600), sui **due lati** | 120 |
| **4** | 🔢 **0a + criteri** | si contano le operazioni (**valvola R59**), poi il codice applica i criteri **cella per cella** | — |

**≈145 passate a tick reali.** ⏱️ **[STIMA, non una previsione]: 50-120 minuti**
più la compilazione.

⚠️ **Fasi valide per `-SoloFase`: `COSTO` · `RIF` · `GRIGLIA`** — attenzione,
**`RIF`, non `METRO`**: qui la fase è stata rinominata apposta (vedi sopra).

---

## ✍️ [LE TRE INTERPRETAZIONI] — identiche al round Dow

Sono **le stesse tre approvate stamattina**, riportate in breve.

### 1️⃣ Il cancello del costo ha **TRE stati**, non due

| take **lordo** mediano | stato | cosa fa il round |
|---|---|---|
| **> 7,0** punti indice (>3,5× lo spread) | ✅ **SUPERATO** | prosegue |
| **5,0 – 7,0** (2,5×–3,5×) | 🟡 **SOSPESO** | **prosegue**, col cappello *«il costo non è dimostrato sopra la soglia»* |
| **< 5,0** (<2,5×) | 🔴 **FALLITO** | 🛑 **si ferma** |

Nella banda **5,0–6,0** l'interpretazione **allarga** un cancello congelato (il
criterio firmato direbbe «si ferma»). Motivo: lo spread è **dichiarato**, non
misurato.
📐 **La conversione qui è MISURATA, non assunta:** su NASUSD 1 punto indice =
**100 punti MT5** = 1,00 di prezzo — è un **gate firmato di R97**, nato perché
R88 aveva dovuto correggere la premessa sbagliata *«1 punto indice = 10 point»*.

### 2️⃣ Con le **parziali accese**, «il take» non è un numero solo

**take per GAMBA** (la più conservativa) **fa il verdetto**; **take per
POSIZIONE** (media pesata sui volumi) è **informativo** e si stampa accanto.

### 3️⃣ Il criterio cerca la regione **dentro l'OOS**: è uno **SCREENING**

Il codice applica il criterio firmato così com'è, **e in più** stampa la lettura
walk-forward onesta sotto ogni griglia.

---

## 📐 QUALE CANCELLO MORDE, LATO PER LATO — calcolato adesso, non dopo

| lato | riferimento agli atti (R107, M5) | cosa chiede il «+0,10» | cancello che MORDE |
|---|---|---|---|
| **LONG** | IS +1.371 · PF 1,080 · n 85 · **OOS +1.873 · PF 1,110 · DD 5,62% · n 113** | ~**1,21** | il **+0,10** |
| **SHORT** | IS +8.399 · PF **3,220** · n 58 · **OOS −10.569 · PF 0,460 · DD 11,34% · n 59** | 0,56 → **lontano dal pavimento** | il **PF ≥ 1,10 ASSOLUTO** |

Vanno superati **tutti e due**, sempre.

> 🔍 **Il dettaglio short, pre-dichiarato**: IS PF 3,220 → OOS PF 0,460 è **la
> firma già fotografata da R107** su questo simbolo e questo lato — *l'edge dello
> short vive nelle DISCESE, e la discesa documentata (feb-apr 2025) sta nell'IS
> mentre l'OOS è quasi tutto salita*. Resta **[INFERITO]**: R107 non misura i
> sotto-periodi. Se si ripete anche qui, **non è un'anomalia da spiegare**.
>
> 📉 **E il campione è SOTTILE:** 113 e 59 operazioni OOS stanno **sotto le 150**
> dell'Emendamento A. Come in R107 (cancello G4), su questa famiglia il
> **MERITO resta SOSPESO per campione**. Il **RISCHIO** no: quello si giudica
> sempre, perché un drawdown è un fatto accaduto.

---

## 🧩 IL BLOCCO R30 — 15 input che esistono **solo** su questo EA

`InpUseVolRegime` (regime di volatilità adattivo) e `InpUseSRFilter` (filtro
S/R) sono stati aggiunti nel round 30 e **mai validati**. Qui sono pinnati
**SPENTI**, e il driver **lo impone con un gate**.

**MISURATO nel sorgente il 25/08 (R107):** `UpdateVolRegime()` ritorna alla prima
riga se l'interruttore è falso, `VolRegimeSL()` ritorna lo stop invariato,
`SRBlocked()` ritorna `false` subito. 👉 **Con i due interruttori a 0, il motore
Nasdaq È il motore Dow.**

I 13 sotto-parametri restano pinnati ai loro default **anche se inerti**: così i
cinque file del round hanno lo **stesso elenco di parametri** e il gate della
stella può confrontarli riga per riga.

🧪 **Il gate è stato fatto scattare**: con `InpUseVolRegime=1` il driver si ferma
prima di aprire MT5 (vedi il referto di preparazione).

---

## 🔐 I MAGIC — tutti **vergini**, la sedia spenta **vietata lo stesso**

| file | magic gemelli |
|---|---|
| griglia **LONG** | `782100` / `782101` |
| griglia **SHORT** | `782200` / `782201` |
| riferimento **LONG** | `782300` / `782301` |
| riferimento **SHORT** | `782400` / `782401` |
| **cancello del costo** | `782500` / `782501` |

Tutti **verificati con grep su tutto il repo il 28/08** (`.git` escluso): i
blocchi `7821xx`-`7825xx` erano a **zero occorrenze**.

🔴 **`770201` è nella lista dei VIETATI anche se la sedia è spenta**:
**un'identità spenta resta un'identità occupata** (è la formula di R107), e la
**porta di rientro** del criterio C3 potrebbe riaccenderla domani.
🔴 Vietati anche i magic **bruciati**: `761200/761201` (R107), `777010…777031`
(R83 su NASUSD), i cinque blocchi del round **Dow** e i cinque del round **DAX**.

🔴 **Il cancello ha un magic TUTTO SUO**: l'export per-trade porta il magic nel
nome del file, quindi una griglia che condividesse il magic **cancellerebbe la
prova del gate** (CHECKLIST 41).

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** La riga si rifiuta di partire in
  tutti e due i casi.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare: `walkforward_generico.ps1` **non lo fa**.
- 🔨 **Il giro a vuoto COMPILA DAVVERO**, e cancella l'`.ex5` prima (CHECKLIST 54).
- **NESSUNA SEDIA VIENE TOCCATA.** Magic vergini, `AllowLiveTrading=false` in
  **tutti** gli `.ini` (CHECKLIST 51).
- **Banco:** `Model=4` (**tick reali**), finestra **2024.09.26 → 2026.06.30**,
  split 40/60 (**IS** fino al `2025.06.09`, **OOS** dal `2025.06.10` — le stesse
  di R101/R107), deposito **100.000**, rischio **1%** (pinnato nei file prova; il
  default compilato del `.mq5` è **2.0%** e il referto lo dichiara), `Spread=0`
  **scritto nell'ini**.
- 📐 **Il DD si legge ×0,65** per portarlo alla taglia prop 100k.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.

---

## 📌 IL PIN — **b40c62c3652286a792e5f6fbdb96cac5898480f5**

```
b40c62c3652286a792e5f6fbdb96cac5898480f5
```

✅ **Pin VERIFICATO il 28/08**: commit esistente su `origin/lavoro`, e i **nove**
artefatti che lo script scarica hanno a quel commit lo **stesso contenuto** che
hanno adesso sul branch (`git cat-file -s` su tutti e nove).

⚠️ **Il pin si rilegge DOPO il push.** Il commit deve contenere **tutti e nove**
gli artefatti che lo script scarica: `walkforward_generico.ps1`,
`RIGA_PREOPEN_NAS.ps1`, i **cinque** file prova, `ABTG_PausaGuardian.mqh` e
**`ABTG_Nasdaq_Apertura_US.mq5`**.

Il driver **pinna anche `$EABranch` dentro `walkforward_generico.ps1`**,
altrimenti il pin varrebbe per il driver e **non per l'EA misurato**.

### ♻️ LA RICETTA DI **RI-PINNATURA**

```bash
F=backtest_pipeline/righe/RIGA_PREOPEN_NAS_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9A-Za-z]{40}'" "$F" | head -1 | grep -oE "[0-9A-Za-z]{40}")
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
sed -n '1,/LA RICETTA DI/p' "$F" | grep -ci "segnaposto\|non funziona\|la riga non parte"   # DEVE dare 0
```

⚠️ **Servono TUTTI E TRE i conteggi** (punti 77 e 101; il terzo va letto **solo
sopra la ricetta**, non su tutto il file — la ricetta stessa nomina
"segnaposto"/"non funziona" nella propria prosa, un `grep` largo non
darebbe mai 0), e il perimetro è
**questo file e basta**, perché la riga di lancio **esiste in un posto solo**
(CHECKLIST 100):

```bash
grep -rn "RIGA_PREOPEN_NAS.ps1" --include=*.md .
```

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata di misura; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='b40c62c3652286a792e5f6fbdb96cac5898480f5'; $p="$env:USERPROFILE\RIGA_PREOPEN_NAS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_NAS.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_NAS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine (righe verificate eseguendo il driver su un banco
stubbato il 28/08):

- `pin ......... <40 caratteri>` · `fasi ........ COSTO -> RIF -> GRIGLIA (tutte)`
  — 👀 **`RIF`, non `METRO`**;
- `IS ....... 2024.09.26 - 2025.06.09` e `OOS ...... 2025.06.10 - 2026.06.30`;
- `file prova scaricati: 5`;
- `sorgente EA al pin: <n> righe, InpRiskPercent di default 2.0%`
  — **2.0 è il default del `.mq5`**, i file prova lo pinnano a **1.0**;
- `assi letti nel file prova: InpPrevWindowMin 5 valori, InpRetestOffsetPts 3
  valori -> 15 celle x 2 gemelli = 30 passate per finestra e per lato`;
- `geometria, lati, RangeMode, baseline, stella, magic e assi: TUTTI PASSATI
  (cella del cancello: PrevWindowMin=180, RetestOffsetPts=400, magic 782500)`;
- `terminale scelto: ...` → deve contenere **`BCM Markets MT5 Terminal`** e
  **non** contenere `-V3` (stesso selettore di `walkforward_generico.ps1`);
- `include: INSTALLATO e VERIFICATO in ...`;
- **`compilato ABTG_Nasdaq_Apertura_US: OK (<n> KB, <ora>)`**;
- `ini della passata singola scritto e verificato: ...`;
- `NON ESEGUITO (giro a vuoto: ...)`;
- quattro blocchi `=== 5. <lavoro> ===` — **`rif_long`, `rif_short`,
  `griglia_long`, `griglia_short`** — con `celle attese per finestra:` **6, 6,
  30, 30**, e in fondo `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Nessun `n`, nessun PF, nessun DD, **nessun controllo sui gemelli**, e
> **il cancello del costo non è stato eseguito**. Conferma gli **artefatti**,
> mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='b40c62c3652286a792e5f6fbdb96cac5898480f5'; $p="$env:USERPROFILE\RIGA_PREOPEN_NAS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_NAS.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_NAS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

### 🔁 Se serve riprendere una fase sola

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`: quando quel blocco finisce **non esistono più**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='b40c62c3652286a792e5f6fbdb96cac5898480f5'; $p="$env:USERPROFILE\RIGA_PREOPEN_NAS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_NAS.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_NAS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloFase 'GRIGLIA' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - normale su una ripresa: lo zip esiste, mandalo' -ForegroundColor Yellow } }
```

Fasi valide: **`COSTO`** · **`RIF`** · **`GRIGLIA`**.

> 🔴 **UNA RIPRESA NON DÀ MAI UN VERDETTO DEFINITIVO.** I CSV delle fasi non
> rilanciate vengono letti da disco e marcati **`DA DISCO <data>`**; il referto
> stampa *«NESSUNO DEI VERDETTI QUI SOPRA È DEFINITIVO»* e **l'uscita è 1**.

---

## 🔢 IL CODICE D'USCITA HA UN SIGNIFICATO SOLO

| codice | vuol dire |
|---|---|
| **0** | un round **COMPLETO**, in **UN LANCIO SOLO**, **senza problemi** |
| **1** | **tutto il resto**: fermato, problemi, riprese, `-SoloFase`, dati da disco |

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PREOPEN_NAS_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PREOPEN_NAS.txt`** ← **è questo che conta**;
- i **cinque file prova**;
- gli **8 CSV** `ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_{rif_long,rif_short,griglia_long,griglia_short}.csv`;
- **`gen_preopen_costo.ini`** e **`REPORT_COSTO.htm`**;
- `COMPILAZIONE_FALLITA.log`, **se** la compilazione fallisce.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto: **non si
   manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

---

## 🚩 COME SI LEGGE IL REFERTO — cinque avvertenze

1. 🚧 **Il cancello del costo viene PRIMA.** Se dice `FALLITO`, non c'è nessuna
   griglia nel referto, ed è giusto così.
2. 📐 **Il riferimento su M15 potrebbe non riprodurre i numeri di R107** (che
   sono su **M5**). **Non è un gate** — e qui non potrebbe esserlo, perché non
   c'è un G0. Il denominatore del round è **il numero misurato adesso**.
3. ⏱️ **Confondimento di 35 MINUTI**: il candidato arma alle **14:30**, il
   riferimento alle **15:05** — finestra **3h00 contro 2h25**, **+24%**.
   👉 **È il caso peggiore dei tre gemelli** (sul DAX gli stessi 35 minuti
   valgono +6,5%). Parte del vantaggio del candidato **è tempo, non livello**.
4. 🎚️ **Guarda la riga dei VOLUMI del cancello.** Valori distinti = **1** e
   volume al minimo del broker ⇒ il lotto ha sbattuto sul pavimento
   `VOLUME_MIN`, e **i DD del round sottostimano il rischio**. Sui bordi larghi
   della griglia **non è misurato**: `[DA VERIFICARE]`.
5. 🧊 **Se esce `PASSA`, rileggi il riquadro in cima a questa pagina.** Quattro
   bocciature indipendenti alle spalle: la prima cosa da cercare è il **difetto
   di misura**, non l'edge.

---

## 🚫 QUELLO CHE QUESTO ROUND **NON** DICE

- ❌ **Un `PASSA` NON riaccende la sedia `770201`.** Produce una **cella
  candidata**; il rientro passa dal criterio **C3**, con un'altra firma.
- ❌ **Non c'è nessun gate G0**: il riferimento non riproduce niente, quindi da
  questa corsa **non si può dire che il banco è sano**.
- ❌ **La correlazione col candidato DOW non è misurata qui**, ed è il rischio
  prop più concreto. Passo successivo dichiarato.
- ❌ **Celle rosse ⇒ «il livello non salva la geometria trasposta»**, NON «il
  Nasdaq non ha edge in apertura».
- ❌ **Lo spread non è misurato**: è **dichiarato** 2,0 punti indice.
- ❌ **Il campione resta sotto le 150 op** dell'Emendamento A: il **MERITO** su
  questa famiglia è **SOSPESO per campione**, il **RISCHIO** no.
- ❌ **Un backtest profittevole non è un profitto live.** Broker singolo, costi
  di un feed solo, **un solo regime** (21 mesi rialzisti).
