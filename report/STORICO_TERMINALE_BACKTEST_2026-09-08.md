# 🔪 LA RIGA CHE AMMAZZAVA IL CONTO REALE — ora la chiusura e' CHIRURGICA

**Data:** 08/09/2026 · **Branch:** `lavoro` · **File toccato:** UNO SOLO,
`backtest_pipeline/scarica_storico.ps1`
**Marcatore:** da `MARCATORE_SCARICA_STORICO_v2` a
**`MARCATORE_SCARICA_STORICO_v3_TERMINALE_BACKTEST`**

> Sblocca il **passo 5** di `report/QUARTO_MT5_PIANO.md` (scaricare lo storico
> sul terminale nuovo), che era il tappo davanti al **passo 7** — l'ancora R119.
> **Non tocca nessun EA, nessun preset, nessuna sedia viva, nessun timeframe,
> nessun CSV, nessuna logica di download.** Solo: quale terminale si usa e
> **quale processo si chiude**.

---

## 🔴 IL PERICOLO — non teorico, era una riga di codice

`scarica_storico.ps1`, **riga 413 della v2**:

```powershell
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force
```

**`-Name "terminal64"` = TUTTI i terminali della macchina.** Sul VPS sono
**quattro**:

| cartella programma | conto | cosa c'e' dentro |
|---|---|---|
| `C:\Program Files\BCM Markets MT5 Terminal` | **50503392** (piccolo) | 40 sedie vive, posizioni aperte |
| `... BCM Markets MT5 Terminal -V3` | **50504263** (100k) | sedie in Fase 1 |
| `C:\BCM_Reale` | **10105439** 🔴 **REALE** | **soldi veri, posizioni aperte** |
| `C:\MT5_Backtest` | **50504400** | niente (zero EA) |

Quella riga li chiudeva **tutti e quattro**, senza guardare. Ed e' esattamente
il motivo per cui `report/SONDA_TICK_ORO_ATTENZIONE.md` **vietava il VPS** a
questo script: *"lanciarla li' significherebbe chiudere il terminale del conto
reale mentre ha posizioni vive"*.

C'era anche una **seconda** chiusura indiscriminata, meno citata ma identica:
la riga 222, quella di `-ChiudiMT5`.

---

## 🧠 PRIMA IL MOTIVO, POI IL RIMEDIO — perche' chiudeva MT5

Letto tutto lo script, il motivo e' scritto nel punto 4b (righe 252-268 della
v2) e **non e' capriccio**: il modo automatico **non apre un tester**. Lancia
**il terminale** con `/config:` e un blocco

```ini
[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_storico.set
```

MT5 esegue lo `Script=` di avvio **solo quando quell'istanza parte davvero**.
Se un terminale **sulla stessa cartella dati** e' gia' aperto, il secondo
avvio si limita a portare in primo piano quello vivo: lo script **non parte**,
il referto non esce, il CSV resta a zero byte. E' scritto anche nel messaggio
d'errore della v2 (*"un secondo avvio sulla stessa cartella dati non esegue lo
script"*).

> ### 🎯 QUINDI IL VINCOLO VERO E': **"QUELLA installazione dev'essere chiusa"**,
> ### non "la macchina dev'essere senza MT5".
> La v2 confondeva le due cose. La strada piu' semplice che rispetta il motivo
> non e' aggirarlo: e' **restringere la chiusura all'installazione che serve**.
> Il metodo non cambia di un millimetro; cambia solo il raggio dell'ascia.

---

## ✅ COSA FA ORA — il diff, commentato

`git diff --stat` → **1 file, +271 / -24**, in **11 hunk**. Le 24 righe tolte
sono righe **spostate o rientrate** (testa, `param`, punto 1, punto 4b,
chiusura finale), non logica cancellata: i due confronti meccanici in fondo lo
dimostrano riga per riga.

### 1. Il parametro `-TerminaleBacktest` (hunk 4, `param`)

```powershell
[string] $TerminaleBacktest = ""   # CARTELLA PROGRAMMA del terminale, es. "C:\MT5_Backtest"
```

**Stessa forma e stesse guardie di `walkforward_generico.ps1` v4** (punto
7-bis): sono state **riusate**, non reinventate. Stesse condizioni, stessi
messaggi, stesso ordine.

### 2. Il blocco `1-bis` — muore in quattro casi (hunk 6)

| caso | cosa stampa (verificato ESEGUENDO, vedi collaudo) |
|---|---|
| percorso con **`-V3`** o **`BCM_Reale`** | `TERMINALE VIETATO in -TerminaleBacktest` + i numeri di conto in chiaro (50504263 / 10105439) |
| cartella **inesistente** | `la cartella NON esiste.` + `cercata : '...'` + come si passa quella giusta |
| cartella senza **`terminal64.exe`** | `cartella : '...'` + `cercato : '...\terminal64.exe'` + la riga di sola lettura `Get-Process terminal64 \| Select-Object Id, MainWindowTitle, Path` |
| cartella senza **`metaeditor64.exe`** | `senza compilatore lo script MQL5 non si compila` + i due percorsi |

🔴 **Le guardie NON si allentano perche' il percorso e' scritto a mano**: anzi,
e' proprio quando si scrive a mano che si sbaglia riga.

### 3. La ricerca automatica resta, ma sotto un `if` (hunk 6-7)

```powershell
if (-not $instDir) {
  $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" ...   # <- le 4 righe di sempre
}
```

Con il parametro vuoto il blocco `1-bis` **non fa niente**, `$instDir` resta
vuoto e la ricerca parte **identica**. Provato col diff (sotto).

### 4. Dichiara SEMPRE il terminale scelto (hunk 8)

```
--- TERMINALE SCELTO ------------------------------------------------
    terminal64 : C:\MT5_Backtest\terminal64.exe
    cartella   : C:\MT5_Backtest
    dati       : C:\Users\...\AppData\Roaming\MetaQuotes\Terminal\<codice>
    via        : parametro esplicito -TerminaleBacktest
---------------------------------------------------------------------
```

E sul ripiego dice una cosa che **va saputa**: la ricerca automatica guarda
**solo sotto Program Files**, quindi `C:\MT5_Backtest` **non verrebbe mai
trovato da sola**. Sul VPS il parametro non e' un'opzione: e' l'unica strada.

### 5. 🔪 LA CHIUSURA CHIRURGICA (hunk 9, 10, 11)

Tre funzioni nuove in cima (`Normalizza-Percorso`, `Scegli-Terminali`,
`Stampa-Terminali`) piu' `Avviso-ChiusuraTotale` e `Muori`. Il cuore:

```powershell
function Scegli-Terminali {
  param($Processi, [string]$EsePath)
  $bersagli = @(); $risparmiati = @()
  $mira = Normalizza-Percorso $EsePath
  foreach($p in @($Processi)){
    if($null -eq $p){ continue }
    $path = ""
    try { $path = [string]$p.Path } catch { $path = "" }   # Path illeggibile = si risparmia
    if($mira -ne "" -and (Normalizza-Percorso $path) -eq $mira){ $bersagli += $p }
    else { $risparmiati += $p }
  }
  return [pscustomobject]@{ Bersagli = @($bersagli); Risparmiati = @($risparmiati) }
}
```

Tre scelte dichiarate, ognuna col suo perche':
- **confronto di UGUAGLIANZA, mai `-like`**: un match per prefisso
  scambierebbe `C:\MT5_Backtest` con `C:\MT5_Backtest_OLD` (caso provato);
- **`Path` illeggibile → si RISPARMIA**, mai si ammazza nel dubbio;
- **`$EsePath` vuoto → zero bersagli**: un bug a monte non puo' trasformarsi in
  una strage a valle.

E **stampa sempre le due liste, con PID e percorso**, prima e dopo:

```
  CHIUDO SOLO questo (terminale da backtest):
      PID 4444     C:\MT5_Backtest\terminal64.exe
  NON TOCCO questi (forward e conto reale):
      PID 1111     C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe
      PID 2222     C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe
      PID 3333     C:\BCM_Reale\terminal64.exe
  --- PROVA, DOPO LA CHIUSURA ---
  ancora vivi (attesi: gli altri terminali, intatti):
      ...
```

👉 **La prova che il forward non e' stato toccato finisce nel referto**, non
nella fiducia.

### 6. Senza il parametro: identico, ma non piu' muto (hunk 10, 11)

```
#####################################################################
  ATTENZIONE: -TerminaleBacktest NON e' stato passato.
  In questa modalita' lo script chiude TUTTI i terminali MT5 della
  macchina, senza distinguere: forward, 100k e CONTO REALE compresi.
#####################################################################
  Terminali che verrebbero chiusi TUTTI:
      PID ...  <elenco con percorso>
  Sul VPS la riga giusta e':
    -TerminaleBacktest "C:\MT5_Backtest"   (conto demo 50504400)
```

poi, **se non c'e' `-Auto`**, chiede: `Scrivi CHIUDITUTTO per continuare`.
La chiusura finale resta **la riga 413 com'era**, preceduta dall'elenco di cosa
sta per chiudere.

> ### ⚠️ ONESTA' SUL CANCELLO DELLA CONFERMA — va detto, non nascosto
> Il punto 4b **si raggiunge solo con `-Auto`** (senza, lo script esce in
> modalita' manuale molto prima, alla riga `if (-not $Auto) { ... exit 0 }`).
> Quindi **oggi la domanda non scatta mai**: quello che protegge davvero e'
> **l'avviso rosso con l'elenco** + il parametro nuovo. La domanda e' codice
> vero e scatterebbe se un domani quel percorso diventasse raggiungibile senza
> `-Auto`, ma **spacciarla per la protezione attiva sarebbe una bugia.**

---

## 🔬 I CONTROLLI — tutti eseguiti, tutti qui

### (a) ASCII puro ✅

```
LC_ALL=C grep -n '[^ -~<TAB>]' backtest_pipeline/scarica_storico.ps1
   -> NESSUNA RIGA (uscita 1). Zero emoji, zero accenti, zero tab.
```

### (b) Sintassi ✅

```
pwsh -NoProfile -Command '...Parser::ParseFile...'
   -> SINTASSI OK
```

### (c) 🚪 IL COLLAUDO DELLA SELEZIONE, ESEGUITO OFFLINE — 9 casi su 9

Le funzioni **non** sono state ricopiate nel banco: sono **estratte dallo
script vero** con l'AST di PowerShell (`FunctionDefinitionAst`) e valutate. I
processi sono **finti** (`[pscustomobject]@{Id;Path}`): qui MT5 non c'e', e
**nessun processo e' stato toccato**.

I quattro terminali finti, mira su `C:\MT5_Backtest\terminal64.exe`:

```
  insieme finto di partenza:
      PID 1111     C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe
      PID 2222     C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe
      PID 3333     C:\BCM_Reale\terminal64.exe
      PID 4444     C:\MT5_Backtest\terminal64.exe
  BERSAGLI (attesi: solo PID 4444):
      PID 4444     C:\MT5_Backtest\terminal64.exe
  RISPARMIATI (attesi: 1111, 2222, 3333):
      PID 1111     C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe
      PID 2222     C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe
      PID 3333     C:\BCM_Reale\terminal64.exe
```

| esito | caso | bersagli | risparmiati |
|---|---|---|---|
| ✅ OK | quattro terminali, mira sul backtest | `4444` | `1111,2222,3333` |
| ✅ OK | stessa mira in MAIUSCOLO | `4444` | `1111,2222,3333` |
| ✅ OK | stessa mira con slash rovesciati (`C:/...`) | `4444` | `1111,2222,3333` |
| ✅ OK | **trappola del prefisso**: esiste anche `C:\MT5_Backtest_OLD` | `4444` | `1111,2222,3333,5555` |
| ✅ OK | un processo con `Path` illeggibile (`$null`) | `4444` | `1111,2222,3333,6666` |
| ✅ OK | **mira VUOTA: non si ammazza niente** | *(nessuno)* | tutti e 4 |
| ✅ OK | mira sul reale (prova di simmetria) | `3333` | `1111,2222,4444` |
| ✅ OK | nessun processo vivo | *(nessuno)* | *(nessuno)* |
| ✅ OK | il backtest e' aperto DUE volte | `4444,7777` | `1111,2222,3333` |

**`COLLAUDO SELEZIONE: 9 casi su 9 OK`.**

> Il settimo caso e' li' apposta ed e' scomodo: la funzione, **da sola**,
> selezionerebbe anche il conto reale se qualcuno la puntasse li'. Non e' un
> buco: **e' a monte che non ci si arriva**, perche' il blocco `1-bis` muore
> su `BCM_Reale` prima che `$Terminal` esista (caso provato al punto (d)).
> Due cancelli distinti, dichiarati tutti e due.

### (d) Le guardie del parametro, ESEGUITE con cartelle finte — 7 casi su 7

Blocco `1-bis` estratto dalle **righe 191-236 dello script vero** e lanciato in
`pwsh` con cartelle finte:

| caso | esito | uscita |
|---|---|---|
| cartella BUONA (`terminal64.exe` + `metaeditor64.exe`) | sceglie, `via = parametro esplicito -TerminaleBacktest` | **0** |
| cartella buona **con `\` finale** | **normalizzata**, sceglie uguale | **0** |
| cartella INESISTENTE | `la cartella NON esiste` + percorso cercato | **1** |
| senza `terminal64.exe` | muore coi due percorsi in chiaro | **1** |
| senza `metaeditor64.exe` | muore coi due percorsi in chiaro | **1** |
| **`-V3`** | `TERMINALE VIETATO` + conti 50504263 / 10105439 | **1** |
| **`BCM_Reale`** | `TERMINALE VIETATO` + conti 50504263 / 10105439 | **1** |
| *(nessun parametro)* | `$instDir` resta vuoto → parte il ripiego di sempre | **0** |

### (e) LA NON-REGRESSIONE, provata col diff

Estratte da HEAD e dalla versione nuova le due regioni che contano, tolte le
sole righe **aggiunte** (etichetta `$ViaTerminale`, avviso, riga VPS):

```
== RICERCA AUTOMATICA ==            >>> IDENTICA (diff vuoto)
== PRE-CONTROLLO SENZA PARAMETRO == >>> IDENTICO (diff vuoto)
```

Righe escluse dal confronto, dichiarate una per una: `$instDir = $cand...` e
`$ViaTerminale = ...` (assegnano, non decidono), `Avviso-ChiusuraTotale
$tuttiTerm` e la riga `SUL VPS la strada e' -TerminaleBacktest` (stampano, non
decidono). **Nessuna riga di lancio gia' scritta cambia di una virgola.**

### (f) Il marcatore v2 e' rimasto NEL FILE, di proposito

Nessuna riga di lancio del repo cerca `MARCATORE_SCARICA_STORICO_v2`
(verificato con `grep -rn` su tutto il repo: l'unica occorrenza era lo script
stesso), ma la stringa resta comunque, come per il v3 di
`walkforward_generico.ps1`: cio' che quel marcatore prometteva e' invariato.

---

## 🚀 LA RIGA DI LANCIO — storico sul terminale nuovo

> ⚠️ **Terminale: conto 50504400, cartella programma `C:\MT5_Backtest`.**
> **NON e' il piccolo 50503392** (`BCM Markets MT5 Terminal`), **non e' il 100k
> 50504263** (`... -V3`), **non e' il reale 10105439** (`C:\BCM_Reale`).
> La riga stampa i terminali **prima** e **dopo**: si legge quella stampa.

Simboli e finestra **non sono scelti a caso**: sono quelli dell'ancora **R119**
del passo 7 — `@SIMBOLO U30USD` / `@SIMBOLO D30EUR`, `@DAQUANDO 2024.09.26`,
`@PERIODO M5` (letti dai file prova `*_RITARDO.txt`). `M1` serve al tester per
i tick reali (`-Modello 4`).

```powershell
$w="$env:USERPROFILE\abtg_storico"; $p="$w\scarica_storico.ps1";
$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline";
New-Item -ItemType Directory -Force -Path $w | Out-Null;
Remove-Item $p -ErrorAction SilentlyContinue;
irm "$b/scarica_storico.ps1?cb=$(New-Guid)" -OutFile $p -ErrorAction Stop;
if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCARICA_STORICO_v3_TERMINALE_BACKTEST' -Quiet)){ throw 'SCRIPT VECCHIO: manca la v3, quella riga chiuderebbe TUTTI i terminali' };
Write-Host '--- TERMINALI PRIMA ---'; Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,Path | Format-Table -AutoSize;
& powershell -NoProfile -ExecutionPolicy Bypass -File $p -TerminaleBacktest "C:\MT5_Backtest" -Simboli 'D30EUR,U30USD' -Da '2024.09.26' -Timeframes 'M1,M5' -TimeoutMin 240 -Auto -ChiudiMT5 2>&1 | Tee-Object -FilePath "$w\storico_console.txt";
Write-Host '--- TERMINALI DOPO (devono essere ANCORA TRE) ---'; Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,Path | Format-Table -AutoSize;
$d="$env:USERPROFILE\Desktop\STORICO_MT5BACKTEST"; Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory -Force -Path $d | Out-Null;
Get-ChildItem "$env:USERPROFILE\Desktop\storico_bcm" -File -ErrorAction SilentlyContinue | Copy-Item -Destination $d -Force;
Copy-Item "$w\storico_console.txt" -Destination $d -Force -ErrorAction SilentlyContinue;
Compress-Archive -Path "$d\*" -DestinationPath "$env:USERPROFILE\Desktop\STORICO_MT5BACKTEST.zip" -Force;
Get-ChildItem $d | Select-Object Name,Length | Format-Table -AutoSize
```

**Sintassi della riga: verificata col parser** (`RIGA STORICO: SINTASSI OK`).

### 🔴 GLI APICI SONO OBBLIGATORI — classe 65, gia' pagata il 07/09
`-Simboli 'D30EUR,U30USD'` e `-Timeframes 'M1,M5'` **con gli apici**. Senza,
PowerShell lega `M1,M5` come **array** e allo script arriva `"M1 M5"` (con lo
spazio): il `.mq5` splitta **solo sulla virgola** → nessun timeframe
riconosciuto → **zero righe di barre**, mentre la riga TICK (che sta fuori dal
ciclo) viene scritta lo stesso e **il referto esce VERDE**. Un referto verde su
una misura mai fatta.

### I file attesi sul Desktop (in `STORICO_MT5BACKTEST` e nello zip)

```
ABTG_StoricoScaricato.csv     <- il referto: Simbolo, Timeframe, Barre, PrimaDataServer, Verdetto
<ultimi 2 log di MT5>.log
storico_console.txt           <- LA PROVA: le liste BERSAGLIO / LASCIATI VIVI con PID e percorso
```

### ✅ COME SI LEGGE L'ESITO, in tre gesti
1. In `storico_console.txt`, il riquadro **`--- TERMINALI MT5 VISTI ADESSO ---`**:
   **BERSAGLIO** deve contenere **solo** un percorso sotto `C:\MT5_Backtest`;
   **LASCIATI VIVI** deve contenere **gli altri tre**, `C:\BCM_Reale` compreso.
2. `--- TERMINALI DOPO ---` deve stampare **tre PID**, e **nessuno** con `Path`
   sotto `C:\MT5_Backtest`.
3. Nel CSV, la colonna **`PrimaDataServer`**: e' la data VERA da cui parte lo
   storico, quella da confrontare con `@DAQUANDO 2024.09.26`. Se e' piu' avanti,
   **l'ancora R119 non e' riproducibile su quel terminale** e va detto prima di
   girare, non dopo.

### 🥇 LA SECONDA RIGA — la sonda tick dell'ORO, ora possibile sul VPS
Stessa forma, cambiano tre argomenti (e **ora puo' girare sul VPS**, cosa che
`SONDA_TICK_ORO_ATTENZIONE.md` vietava proprio per la riga 413):

```
-TerminaleBacktest "C:\MT5_Backtest" -Simboli 'XAUUSD' -Da '2022.01.01' -Timeframes 'M1,M5' -TimeoutMin 240 -Auto -ChiudiMT5
```

---

## ⚠️ TRE COSE DA SAPERE PRIMA DI LANCIARE — dichiarate, non nascoste

1. 🔴 **Qui non c'e' MT5 e non c'e' Windows.** Nessun download e' stato
   eseguito. Quello che e' provato e' la **selezione dei processi** (9/9), le
   **guardie** (7/7), l'**ASCII**, la **sintassi** e la **non-regressione**.
   Che MT5 scarichi davvero lo storico su quel terminale lo dira' la corsa.
2. **`-ChiudiMT5` adesso e' innocuo, ma solo INSIEME a `-TerminaleBacktest`.**
   Da solo resta la mannaia di sempre: chiude tutto. Nella riga sopra ci sono
   entrambi, ed e' voluto — il terminale nuovo sara' aperto (Claudio ci ha
   fatto il login), e senza `-ChiudiMT5` lo script morirebbe li'.
3. **La cartella dati dev'esistere**: `C:\MT5_Backtest` dev'essere stato aperto
   almeno una volta col login **50504400**, altrimenti `origin.txt` non esiste e
   lo script muore con `Cartella dati MT5 non trovata`. Dal passo 2 del piano
   risulta fatto.

---

## 📌 IN UNA RIGA

Lo script non ammazza piu' quello che capita: **o gli dici quale terminale
chiudere, o ti stampa in faccia che sta per chiuderli tutti** — e quando glielo
dici, **stampa PID e percorso di chi ha lasciato vivo**, conto reale compreso.
