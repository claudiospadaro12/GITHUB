# 🎯 IL DRIVER ORA PUNTA UN TERMINALE PRECISO — passo 6 del QUARTO MT5

**Data:** 08/09/2026 · **Branch:** `lavoro` · **File toccato:** UNO SOLO,
`backtest_pipeline/walkforward_generico.ps1`
**Marcatore:** da `MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE` a
**`MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST`**

> Chiude il passo 6 di `report/QUARTO_MT5_PIANO.md`.
> **Non tocca nessun EA, nessun preset, nessuna sedia viva, nessun `.ini`,
> nessuna finestra IS/OOS, nessun `ExecutionMode`.** Solo la scelta del
> terminale. Il diff qui sotto lo dimostra: **8 hunk, 114 righe aggiunte,
> 4 modificate**, e tutte e 4 sono il marcatore o una riga a cui e' stata
> appesa la sola dichiarazione della via.

---

## 🔴 COSA FACEVA PRIMA — e perche' dal 07/09 non bastava piu'

Il driver sceglieva il terminale **solo per inferenza**, al punto 7:

```powershell
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe"
$c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and
                               $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
# ...e se non trova niente, il RIPIEGO:
$c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and
                               $_.DirectoryName -notlike "*-V3*" -and
                               $_.DirectoryName -notlike "*BCM_Reale*" } | Select-Object -First 1
```

Con **tre** installazioni quel filtro ne lasciava passare **una sola**, e
`Select-Object -First 1` non era una scelta: era l'unica possibilita'.

**Dal 07/09 le installazioni sono QUATTRO** (`C:\MT5_Backtest`, conto demo
**50504400**, HEDGING verificato dal giornale in
`backtest_pipeline/coda/referti/CODA_03_conti_dei_terminali_20260908_033003.log`,
**zero EA attaccati** — `CODA_01`, profilo attivo vuoto). Da quel momento
`*BCM Markets*` non `-V3` non `BCM_Reale` ne lascia passare **DUE**:

| cartella | conto | cosa c'e' dentro | passava il filtro? |
|---|---|---|---|
| `BCM Markets MT5 Terminal` | **50503392** (piccolo) | **40 sedie vive, posizioni aperte** | ✅ **SI** |
| `... -V3` | 50504263 (100k) | sedie in Fase 1 | ❌ no (guardia) |
| `C:\BCM_Reale` | 10105439 (**REALE**) | soldi veri | ❌ no (guardia) |
| `C:\MT5_Backtest` | **50504400** | niente | ✅ **SI** |

👉 **Due candidati, e a decidere sarebbe stato l'ordine di
`Get-ChildItem`.** E' la **classe 37-quater** pagata il 07/09 in persona: un
ripiego che sceglie il terminale sbagliato **e non lo dice**.

---

## ✅ COSA FA ORA

### 1. Il parametro `-TerminaleBacktest` (r.175)

```powershell
[string]$TerminaleBacktest = "",   # CARTELLA PROGRAMMA del terminale, es. "C:\MT5_Backtest"
```

Se valorizzato si usa **quello e solo quello**: il blocco nuovo (r.696-749)
sta **prima** dei due blocchi di ripiego, che sono entrambi guardati da
`if(-not $Terminal ...)` e quindi **non partono nemmeno**. Nessuna ricerca,
nessun `-First 1`, nessuna inferenza.

### 2. Muore in **cinque** casi, e ognuno dice cosa ha cercato e dove

| caso | cosa stampa (verificato eseguendo) |
|---|---|
| cartella **inesistente** | `-TerminaleBacktest: la cartella NON esiste.` + `cercata : '...'` + come si passa la cartella giusta |
| cartella c'e' ma **senza `terminal64.exe`** | `cartella : '...'` + `cercato : '...\terminal64.exe'` + la riga in sola lettura `Get-Process terminal64 \| Select-Object Id, MainWindowTitle, Path` |
| cartella c'e' ma **senza `metaeditor64.exe`** | `manca metaeditor64.exe, e senza compilatore l'EA non si compila` + i due percorsi |
| percorso con **`-V3`** o **`BCM_Reale`** | `TERMINALE VIETATO in -TerminaleBacktest` + i numeri di conto in chiaro (50504263 / 10105439) |
| `-TerminaleBacktest` **+** `-Terminal` insieme | `dicono due cose diverse: passane UNO solo` + i due valori |

🔴 **Le guardie NON si allentano.** `-V3` e `BCM_Reale` restano vietati
**anche quando li nomini a mano** — anzi, proprio quando si scrive a mano si
sbaglia riga.

### 3. Dichiara SEMPRE quale terminale ha scelto (r.818-835)

Prima della compilazione e prima di aprire MT5, su **ogni** via:

```
--- TERMINALE SCELTO ------------------------------------------------
    terminal64 : C:\MT5_Backtest\terminal64.exe
    cartella   : C:\MT5_Backtest
    via        : parametro esplicito -TerminaleBacktest
---------------------------------------------------------------------
```

e quando invece ha scelto da solo:

```
    via        : RIPIEGO automatico su BrokerPattern 'BCM'
    (ripiego: nessuna cartella nominata. Se non e' quello che volevi,
     rilancia con -TerminaleBacktest "C:\MT5_Backtest" e non tirare a indovinare.)
```

Le vie possibili sono cinque, tutte etichettate: `parametro esplicito
-TerminaleBacktest`, `parametro esplicito -Terminal`, `RIPIEGO automatico su
BrokerPattern 'BCM'` (+ `con -UseSpare`), `RIPIEGO da origin.txt per
BrokerPattern '<x>'`, `RIPIEGO su Program Files per BrokerPattern '<x>'`.
**Prima di ieri il ramo BCM non stampava NIENTE**: girava e basta.

---

## 🧾 IL DIFF, COMMENTATO

`git diff --stat` → **1 file, +114 / -4**, in **8 hunk**. Le 4 righe
modificate:

| # | riga | cosa cambia | tocca la scelta? |
|---|---|---|---|
| 1 | 2 | marcatore in testa → `v4_TERMINALE_BACKTEST` | no |
| 2 | 201 | il marcatore stampato all'avvio → v4 | no |
| 3 | 778 | al `if($c){$Terminal=...}` del ramo BCM e' **appesa** `$ViaTerminale="RIPIEGO automatico su BrokerPattern 'BCM'"` | **no**: assegna solo l'etichetta |
| 4 | 805 | stessa cosa sul ramo altro-broker | **no** |

Le 114 aggiunte sono: il commento di testa (perche' esiste, 36 righe), il
parametro (9), il blocco `7-bis` (55), la dichiarazione a schermo (18), le
due etichette di via (2).

### Il pezzo che conta, per intero

```powershell
$ViaTerminale=""
if($Terminal){ $ViaTerminale="parametro esplicito -Terminal" }
if($TerminaleBacktest){
  if($Terminal){ Muori "-TerminaleBacktest e -Terminal dicono due cose diverse: passane UNO solo. ..." }
  if($TerminaleBacktest -like "*-V3*" -or $TerminaleBacktest -like "*BCM_Reale*"){
    Muori "TERMINALE VIETATO in -TerminaleBacktest: '$TerminaleBacktest' ..."
  }
  $cartellaBT=$TerminaleBacktest.TrimEnd('\','/')
  if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori "... la cartella NON esiste. cercata: '$cartellaBT' ..." }
  $exeBT=Join-Path $cartellaBT "terminal64.exe"
  if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori "... NON contiene terminal64.exe. cercato: '$exeBT' ..." }
  $medBT=Join-Path $cartellaBT "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $medBT -PathType Leaf)){ Muori "... manca metaeditor64.exe ..." }
  $Terminal=$exeBT
  $MetaEditor=$medBT
  $ViaTerminale="parametro esplicito -TerminaleBacktest"
}
```

---

## 🔬 LA NON-REGRESSIONE, DIMOSTRATA — e come

🔴 **Dichiarazione onesta: qui NON c'e' MT5 e non c'e' Windows.** Nessun
round e' stato eseguito. Quello che segue e' (a) una dimostrazione
**meccanica** sul testo dello script e (b) una prova **eseguita** della sola
logica nuova, su `pwsh` con cartelle finte.

### (a) La logica di scelta e' IDENTICA, provato col diff

Estratta la regione della scelta da HEAD e dalla versione nuova (65 righe),
tolte dalla nuova le **sole** assegnazioni a `$ViaTerminale` (che non
decidono niente: scrivono un'etichetta):

```
diff sel_vecchio.txt sel_nuovo_normalizzato.txt
>>> LOGICA DI SCELTA IDENTICA (diff vuoto)
```

Il ragionamento che regge il risultato: con `-TerminaleBacktest` vuoto il
blocco `7-bis` esegue **solo** `$ViaTerminale=""` e i due `if` non entrano;
`$Terminal` resta vuoto; i due blocchi di ripiego, guardati da
`if(-not $Terminal ...)`, partono **esattamente come prima** e scelgono lo
stesso percorso. **Nessuna riga di lancio gia' scritta cambia di una virgola.**

### (b) I casi nuovi, ESEGUITI su `pwsh` con cartelle finte

9 casi su 9 col comportamento atteso: cartella buona → sceglie e dichiara;
cartella con `\` finale → **normalizzata**, sceglie uguale; cartella
inesistente / senza `terminal64.exe` / senza `metaeditor64.exe` → muore coi
percorsi in chiaro; `-V3` e `BCM_Reale` → muore; `-TerminaleBacktest` +
`-Terminal` → muore; solo `-Terminal` → via `parametro esplicito -Terminal`.
Verificato a parte che `Muori` esce con **codice 1** (l'exit 0 visto nel banco
e' un artefatto del `dot-source` dell'impalcatura, non del driver).

### (c) I due controlli obbligatori

```
LC_ALL=C grep -n '[^ -~]' backtest_pipeline/walkforward_generico.ps1
   -> NESSUNA RIGA. ASCII puro, zero emoji, zero tab.   ✅

pwsh -NoProfile -Command '...Parser::ParseFile...'
   -> SINTASSI OK                                        ✅
```

### (d) Il marcatore v3 e' rimasto NEL FILE, di proposito

`righe/RIGA_RITARDO_TESTER.ps1` (r.99 e r.225) — **che e' proprio la riga
dell'ancora R119 del passo 7** — rifiuta il driver se non trova la stringa
`MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE`. Togliendola, quella riga
sarebbe morta dicendo *"driver vecchio"* davanti a un driver **piu' nuovo**.
La stringa e' quindi citata nel commento di testa, con scritto perche':
cio' che il marcatore v3 promette (`-Ritardo` → `ExecutionMode` nell'`.ini`)
qui e' **invariato**, quindi la promessa e' ancora vera. Verificato:

```
Select-String -SimpleMatch "MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE" -Quiet
   -> marcatore v3 ANCORA PRESENTE (RIGA_RITARDO_TESTER passa)   ✅
```

---

## 🚀 LA RIGA DI LANCIO DELL'ANCORA (passo 7) — R119 a `ExecutionMode=0`

> ⚠️ **NON e' ancora il passo 7**, e' la riga d'esempio che il passo 7 usera'.
> Terminale: **conto 50504400**, cartella programma **`C:\MT5_Backtest`**.
> **Non e' il piccolo 50503392, non e' il 100k 50504263 (`-V3`), non e' il
> reale 10105439 (`C:\BCM_Reale`).** La riga lo dichiara e il driver lo
> ristampa: **si legge quella stampa prima di lasciarlo girare.**

```powershell
$w="$env:USERPROFILE\abtg_passo7"; $pr="$w\prove"; $p="$w\walkforward_generico.ps1";
$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline";
New-Item -ItemType Directory -Force -Path $w,$pr | Out-Null;
Remove-Item $p -ErrorAction SilentlyContinue;
irm "$b/walkforward_generico.ps1?cb=$(New-Guid)" -OutFile $p -ErrorAction Stop;
if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST' -Quiet)){ throw 'DRIVER VECCHIO: manca la v4, niente -TerminaleBacktest' };
foreach($f in @("ABTG_ORB_Ottimizzato_RITARDO.txt","ABTG_DAX_Apertura_EU_RITARDO.txt")){ Remove-Item "$pr\$f" -ErrorAction SilentlyContinue; irm "$b/prove/$f`?cb=$(New-Guid)" -OutFile "$pr\$f" -ErrorAction Stop; if(-not (Test-Path "$pr\$f")){ throw "PROVA MANCANTE: $f" } };
Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,Path | Format-Table -AutoSize;
& powershell -NoProfile -ExecutionPolicy Bypass -File $p -Expert ABTG_ORB_Ottimizzato -Prova "$pr\ABTG_ORB_Ottimizzato_RITARDO.txt" -Ritardo 0 -Etichetta R119_ORB_D0000 -Modello 4 -Rifai -Force -TerminaleBacktest "C:\MT5_Backtest";
& powershell -NoProfile -ExecutionPolicy Bypass -File $p -Expert ABTG_DAX_Apertura_EU -Prova "$pr\ABTG_DAX_Apertura_EU_RITARDO.txt" -Ritardo 0 -Etichetta R119_DAX_D0000 -Modello 4 -Rifai -Force -TerminaleBacktest "C:\MT5_Backtest";
$d="$env:USERPROFILE\Desktop\PASSO7_ANCORA_R119"; Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory -Force -Path $d | Out-Null;
Get-ChildItem "$w\risultati_prove" -Recurse -Filter *.csv | Where-Object { $_.Name -like "*R119_*_D0000.csv" } | Copy-Item -Destination $d -Force;
Compress-Archive -Path "$d\*" -DestinationPath "$env:USERPROFILE\Desktop\PASSO7_ANCORA_R119.zip" -Force;
Get-ChildItem $d | Select-Object Name,Length | Format-Table -AutoSize
```

**Sintassi della riga: verificata col parser** (`RIGA PASSO 7: SINTASSI OK`).
Il `` ` `` davanti al `?` nella URL delle prove **serve**: senza, PowerShell
legge `$f?cb` come un nome di variabile e la URL esce monca — misurato.

### I 4 file attesi sul Desktop (in `PASSO7_ANCORA_R119` e nello zip)

```
ABTG_ORB_Ottimizzato_U30USD_IS_R119_ORB_D0000.csv
ABTG_ORB_Ottimizzato_U30USD_OOS_R119_ORB_D0000.csv
ABTG_DAX_Apertura_EU_D30EUR_IS_R119_DAX_D0000.csv
ABTG_DAX_Apertura_EU_D30EUR_OOS_R119_DAX_D0000.csv
```

### 🎯 I NUMERI CHE DEVONO USCIRE, ALLA CIFRA

Presi dai CSV in archivio `backtest_pipeline/risultati_archivio/ritardo_r119b_csv/`
(le colonne sono `Profit, Profit Factor, Equity DD %, Trades`):

| sedia | magic | file | Profit | PF | DD % | Trade |
|---|---|---|---|---|---|---|
| ORB U30USD (STOP) | **770611** | `..._OOS_R119_ORB_D0000.csv` | **2484,17** | **1,67490** | **6,5389** | **119** |
| DAX D30EUR (LIMIT) | **770101** | `..._OOS_R119_DAX_D0000.csv` | **1103,31** | **1,41105** | **4,3501** | **270** |

Ogni CSV ha **due righe** (asse tecnico sul magic: 770611/770661 e
770101/770151) e devono essere **identiche fra loro** — sono i gemelli di
determinismo G1. Se le due righe differiscono, il problema e' la macchina
nuova, non il round.

---

## ⚠️ QUATTRO COSE DA SAPERE PRIMA DEL PASSO 7 — dichiarate, non nascoste

### 1. 🔴 Sul VPS serve `-Force`, e `-Force` costa qualcosa
Il driver ha da sempre questa guardia (r.844):
```powershell
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Muori "chiudi MetaTrader prima di lanciare, altrimenti escono 0 CSV." }
```
**Guarda i PROCESSI, non il terminale scelto.** Sul VPS i tre terminali di
forward sono **sempre aperti**: senza `-Force` **ogni** round muore li'.
Ma `-Force` spegne il controllo **anche per il terminale da backtest** — ed
e' proprio quel caso che produce **0 CSV**. Rimedio nel frattempo, ed e'
nella riga sopra: la stampa `Get-Process terminal64 | Select Id,Path`
**prima** delle corse. Devono uscire **tre** PID e **nessuno** con
`Path` sotto `C:\MT5_Backtest`. *(Restringere quella guardia al solo
terminale scelto e' un lavoro vero, ma NON e' il passo 6: qui si tocca solo
la scelta del terminale. Va messo in coda.)*

### 2. `-SoloControllo` esce PRIMA della scelta del terminale
Il ramo `-SoloControllo` fa `exit 0` alla fine del punto 6, quindi **non**
valida `-TerminaleBacktest` e **non** stampa il riquadro. Non e' grave: sulla
corsa vera la morte arriva **prima** di copiare l'EA, prima di compilare e
prima di aprire MT5 — costa secondi, non una notte. Ma va saputo: il giro a
vuoto della checklist **non** e' la prova che il percorso e' giusto.

### 3. `RIGA_RITARDO_TESTER.ps1` non sa ancora inoltrare il parametro
La riga completa di R119 (8 corse, cancello G0) chiama il driver con una
lista di argomenti fissa e **non ha** `-TerminaleBacktest`. Per l'ancora del
passo 7 servono solo le **due corse a `ExecutionMode=0`**, ed e' quello che
fa la riga qui sopra chiamando il driver **direttamente**. Se un giorno si
vorra' rifare R119 **intero** sul VPS, quella riga va insegnata a inoltrare
il parametro: **e' materia del passo 7, non del 6.**

### 4. E la cartella dati deve esistere
Il driver ricava la cartella dati da `origin.txt` (`%APPDATA%\MetaQuotes\Terminal\...`).
`C:\MT5_Backtest` dev'essere stato **aperto almeno una volta col login
50504400**, altrimenti quella cartella non esiste e il driver muore con
`cartella dati MT5 non trovata`. Dal passo 2 del piano risulta fatto.

---

## 📌 IN UNA RIGA

Il driver non indovina piu' il terminale: **o glielo dici, o ti dice quello
che ha indovinato.** E quando glielo dici, se sbagli cartella **muore
stampando cosa ha cercato e dove**, invece di scrivere nel terminale con
40 sedie vive.
