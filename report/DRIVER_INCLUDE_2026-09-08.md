# 🎯 DIAGNOSI **CONFERMATA**: il driver non portava gli `#include` nostri

**Data:** 08/09/2026 · **Branch:** `lavoro` · **Pin del commit:** `3447eb2`
**File toccati:** DUE — `backtest_pipeline/walkforward_generico.ps1` e
`backtest_pipeline/righe/RIGA_ANCORA_R119.ps1`
**Marcatore driver:** da `..._v4_TERMINALE_BACKTEST` a **`MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE`**
**Marcatore riga ancora:** da `..._R119_v2` a **`MARCATORE_RIGA_ANCORA_R119_v3`**

> 😤 Buona notizia dentro una brutta: il passo 7 non e' morto per un difetto
> del round, dello storico o del terminale. E' morto perche' **al terminale
> nuovo mancava un file di 139 KB.** Si sistema in un pomeriggio, non in una
> settimana. E adesso quando fallira' ce lo dira' **stampando il perche'**.

---

## ✅ 1. LA CONFERMA DELLA DIAGNOSI — file e riga, non fiducia

La diagnosi era da confermare leggendo il codice, non da dare per buona.
**E' confermata, su tre fatti indipendenti.**

### (a) Il driver scaricava SOLO il `.mq5`

`backtest_pipeline/walkforward_generico.ps1` **r.245** (numerazione di HEAD
prima della patch):

```powershell
try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$Expert.mq5" -OutFile $srcFile -UseBasicParsing }
```

Una sola URL, un solo file.

### (b) E copiava SOLO il `.mq5`

**r.852-854**:

```powershell
Copy-Item $srcFile -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$Expert.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$Expert.ex5"))){ Muori "compilazione fallita per $Expert. Apri MetaEditor e guarda gli errori." }
```

### (c) **NESSUN ALTRO PUNTO** del driver tocca un `.mqh` — verificato col grep

```
grep -n "mqh\|Include\|Copy-Item" backtest_pipeline/walkforward_generico.ps1   (versione HEAD)
  -> 852:  Copy-Item $srcFile -Destination $MqlExperts -Force        (il .mq5)
  -> 930:  Copy-Item $csv -Destination $done -Force                  (i CSV dei risultati)
  -> nessuna occorrenza di "mqh" fuori dalle righe 853-854 (la compilazione)
  -> nessuna occorrenza della parola "Include"
```

👉 **Confermato: il driver non ha mai portato un `.mqh` sul terminale.** Sul PC
di backtest e sui tre terminali storici quei file c'erano da mesi e nessuno se
n'era accorto; `C:\MT5_Backtest` (conto demo **50504400**) e' installazione
nuova e vuota, quindi metaeditor non trovava l'include, non produceva l'`.ex5`,
e il driver moriva a **codice 1** — **prima** di aprire MT5. Che e' esattamente
quello che si e' visto: fallimento **immediato**, non dopo ore, e `ESITO: NON
MISURATO -- ZERO CSV letti`.

---

## 📋 2. IL CENSIMENTO DEGLI `#include` — quali servono davvero

Fatto col grep sull'**intero** `mql5/` (Experts + Include), contando solo le
righe `#include` vere (non le citazioni nei commenti):

| include | quante volte | di chi | va copiato? |
|---|---|---|---|
| `<Trade/Trade.mqh>` | **110** | **SISTEMA** | ❌ no, MT5 ce l'ha |
| `<Trade\Trade.mqh>` | **12** | **SISTEMA** | ❌ no |
| `<Trade\PositionInfo.mqh>` | 1 | **SISTEMA** | ❌ no |
| `<Trade\SymbolInfo.mqh>` | 1 | **SISTEMA** | ❌ no |
| `<Trade\AccountInfo.mqh>` | 1 | **SISTEMA** | ❌ no |
| **`<ABTG_PausaGuardian.mqh>`** | **69** | 🔴 **NOSTRO** | ✅ **SI, indispensabile** |

**Non esiste nessun altro `#include`.** Nel repo ci sono altri due `.mqh`
nostri, ma **oggi nessun `.mq5` li include** (dentro gli EA quel codice e'
copiato in linea):

| file nel repo | incluso da qualcuno? | portato lo stesso? |
|---|---|---|
| `mql5/Include/ABTG/ABTG_ApertureCore.mqh` | ❌ nessun `#include` | ✅ si (costa un download, e copre il giorno in cui servira') |
| `mql5/Include/OptFrame.mqh` | ❌ nessun `#include` | ✅ si |

E `ABTG_PausaGuardian.mqh` **non include niente a sua volta** (verificato:
zero righe `#include` dentro il file) — quindi non c'e' una catena di
dipendenze annidate da inseguire.

### 🔴 Le due sedie dell'ancora sono ESATTAMENTE fra le 69

```
mql5/Experts/ABTG_ORB_Ottimizzato.mq5:106:#include <ABTG_PausaGuardian.mqh>
mql5/Experts/ABTG_DAX_Apertura_EU.mq5:132:#include <ABTG_PausaGuardian.mqh>
```

Non era sfortuna: **erano condannate tutte e due, al 100%.**

---

## 🧾 3. IL DIFF, COMMENTATO

`git diff --stat` → **2 file, +162 / -14**.

### `walkforward_generico.ps1` (+151 / -10)

| # | dove | cosa | tocca la logica? |
|---|---|---|---|
| 1 | r.2 | marcatore in testa → `v5_INCLUDE` | no |
| 2 | r.124-146 | commento nuovo: perche' esiste la v5 + compatibilita' marcatori | no |
| 3 | r.228 | marcatore stampato all'avvio → v5 | no |
| 4 | **r.283-322** | **blocco `1-bis`: scarica gli include nostri** | **aggiunta** |
| 5 | r.916 | `$MqlInclude=Join-Path $DataFolder "MQL5\Include"` | aggiunta |
| 6 | r.919 | `New-Item ... -Path $MqlExperts,$MqlInclude,$Results` (era senza `$MqlInclude`) | 1 riga modificata |
| 7 | **r.921-941** | **copia degli include + riquadro DICHIARATO a schermo** | **aggiunta** |
| 8 | **r.945-985** | **morte per compilazione: stampa le ultime righe del log di MetaEditor** | sostituisce 1 riga |

#### Il pezzo che scarica (`1-bis`), per intero

```powershell
$NostriInclude=@(
  @{ Rel="ABTG_PausaGuardian.mqh";     Serve=$true;  Nota="69 EA lo includono (ORB e DAX dell'ancora compresi)" },
  @{ Rel="ABTG/ABTG_ApertureCore.mqh"; Serve=$false; Nota="nel repo, oggi nessun #include" },
  @{ Rel="OptFrame.mqh";               Serve=$false; Nota="nel repo, oggi nessun #include" }
)
$IncDir=Join-Path $Work "src_include"
...
foreach($inc in $NostriInclude){
  $relWin=$inc.Rel.Replace("/","\")            # ABTG/ resta ABTG\ anche in locale
  $dst=Join-Path $IncDir $relWin
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  # stesso schema di ripiego del sorgente (r.245): si prova a scaricare,
  # e se la rete non c'e' si usa la copia gia' scaricata prima.
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Include/$($inc.Rel)" -OutFile $dst -UseBasicParsing }
  catch{
    if(Test-Path $dst){ ...uso la copia locale... }
    elseif($inc.Serve){ Muori "...non riesco a scaricare l'include NOSTRO ... URL provata: ..." }
    else{ ...non e' incluso da nessun EA, tiro dritto...; continue }
  }
  if(Test-Path $dst){ $IncPronti += @{ Rel=$relWin; File=$dst; Nota=$inc.Nota } }
}
```

⚠️ Lo `$RawBase` e' **lo stesso** della r.245 — quindi con `-Pin <sha>` gli
include arrivano dallo stesso commit dell'EA. Niente URL nuove, niente branch
diverso: una sola fonte di verita'.

#### Il riquadro che DICHIARA (perche' un file copiato in silenzio e' un'assunzione)

Stampato **prima** della compilazione, esattamente come il riquadro
`TERMINALE SCELTO`:

```
--- INCLUDE NOSTRI PORTATI SUL TERMINALE -----------------------------
    destinazione : C:\Users\...\MQL5\Include
    ABTG_PausaGuardian.mqh         139333 byte   (69 EA lo includono (ORB e DAX dell'ancora compresi))
    ABTG/ABTG_ApertureCore.mqh     46028 byte   (nel repo, oggi nessun #include)
    OptFrame.mqh                   5413 byte   (nel repo, oggi nessun #include)
    (di SISTEMA, NON copiati perche' MT5 li ha gia': Trade\Trade.mqh,
     Trade\PositionInfo.mqh, Trade\SymbolInfo.mqh, Trade\AccountInfo.mqh)
---------------------------------------------------------------------
```

#### La morte che adesso dice PERCHE'

```powershell
# prima:
if(-not (Test-Path ... "$Expert.ex5")){ Muori "compilazione fallita per $Expert. Apri MetaEditor e guarda gli errori." }
```

Oggi Claudio non aveva **nessun modo** di sapere perche'. Adesso il driver
cerca `<EA>.log` accanto al sorgente (lo scrive metaeditor con `/log`), e se
non c'e' ripiega sul `.log` piu' recente della cartella. Il file lo scrive
metaeditor in **UTF-16**, quindi va letto **a byte e decodificato** (BOM
`FF FE` / `FE FF`, o l'euristica del byte zero in posizione dispari):
leggendolo come testo semplice uscirebbero caratteri a caso. Stampa le
**ultime 25 righe non vuote**, poi muore con:

```
    compilazione fallita per <EA> (nessun .ex5 prodotto).
    Le ultime righe del log di MetaEditor sono stampate qui sopra: si leggono QUELLE.
    Se dicono 'can't open ... .mqh', manca un #include: gli include nostri portati
    da questo driver sono elencati nel riquadro INCLUDE NOSTRI, poco piu' su.
```

### `RIGA_ANCORA_R119.ps1` (+25 / -4)

**Cambia UNA COSA SOLA di sostanza** (r.86):

```powershell
- $MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST"
+ $MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"
```

Senza questa riga **l'ancora rifiuterebbe il driver CORRETTO** dicendo "e'
vecchio" (la r.227 fa `Select-String -SimpleMatch` e muore). Le altre tre
righe sono il marcatore proprio (`v2` → `v3`) e la stringa stampata
("marcatore v4 verificato" → "v5"), piu' 21 righe di commento che spiegano la
classe 161. **Nessun numero atteso, nessuna tolleranza, nessuna guardia sui
terminali e' stata toccata.**

### 🔒 Compatibilita' dei marcatori: `v3` **e** `v4` restano nel file

`righe/RIGA_RITARDO_TESTER.ps1` (r.99 e r.225) cerca ancora
`MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE`, e copie gia' scritte della riga
del passo 7 cercano il `v4`. **Tutte e due le stringhe sono citate di
proposito nel commento di testa del driver**, con scritto perche': cio' che il
v3 promette (`-Ritardo` → `ExecutionMode`) e cio' che promette il v4
(`-TerminaleBacktest`) qui sono **invariati**, quindi le promesse sono ancora
vere. Verificato:

```
grep -n "MARCATORE_WALKFORWARD_GENERICO_v" walkforward_generico.ps1
  2:   #  MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE
  145: #  MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE e
  146: #  MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST. Le righe di lancio gia'
  228: Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" ...
```

---

## 🔬 4. GLI ESITI DEI CONTROLLI

🔴 **Dichiarazione onesta: qui NON c'e' Windows e NON c'e' MT5.** Nessun round
e' stato eseguito, nessun `.ex5` e' stato compilato. Quello che segue e' (a) una
dimostrazione **meccanica** sul testo, (b) prove **eseguite** su `pwsh` con
cartelle finte e con GitHub vero.

### (a) I due controlli obbligatori — ✅ tutti e due, su tutti e due i file

```
LC_ALL=C grep -n '[^ -~\t]' backtest_pipeline/walkforward_generico.ps1        -> NIENTE   ASCII puro
LC_ALL=C grep -n '[^ -~\t]' backtest_pipeline/righe/RIGA_ANCORA_R119.ps1      -> NIENTE   ASCII puro
grep -cP '\t' backtest_pipeline/walkforward_generico.ps1                       -> 0        zero tab
pwsh ... Parser::ParseFile(walkforward_generico.ps1)                           -> OK
pwsh ... Parser::ParseFile(RIGA_ANCORA_R119.ps1)                               -> SINTASSI OK
```

### (b) 🛡️ LA NON-REGRESSIONE, **MISURATA** sulle sole righe eseguibili

Tolti commenti e righe vuote da HEAD e dalla versione nuova, e messi a
confronto:

```
righe eseguibili: prima 645 -> dopo 723
diff -> righe eseguibili SPARITE: TRE, e sono tutte e tre volute:
  1. Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST" ...   (diventa v5)
  2. New-Item -ItemType Directory -Force -Path $MqlExperts,$Results | Out-Null   (ora crea anche $MqlInclude)
  3. if(-not (Test-Path ... "$Expert.ex5")){ Muori "compilazione fallita ..." }  (ora stampa il log)
```

👉 **Zero righe eseguibili tolte dalla logica dei round, dagli `.ini`, dalla
scelta del terminale o dalle guardie.** Le 78 righe eseguibili aggiunte stanno
tutte e sole nei due blocchi nuovi. **Senza `-TerminaleBacktest` il
comportamento resta identico**: il blocco `1-bis` e la copia girano su
qualunque via, e su un terminale che gli include ce li ha gia' si limitano a
riscriverli **con la stessa identica fonte** (il repo) da cui gia' arriva il
`.mq5`.

### (c) 🧪 SEI CASI **ESEGUITI** su `pwsh` 7 con cartelle finte

I due blocchi nuovi sono stati estratti dal file **vero** (nessuna riscrittura:
sul banco Linux e' stato sostituito solo il separatore `\` → separatore di
piattaforma, perche' su Linux il `\` e' un carattere qualunque) e fatti girare:

| # | caso | atteso | esito |
|---|---|---|---|
| A | download **vero** da GitHub (`lavoro`) | 3 file, `ABTG/` conservata | ✅ `PRONTI=3`, albero `MQL5/Include/{ABTG_PausaGuardian.mqh, ABTG/ABTG_ApertureCore.mqh, OptFrame.mqh}`, byte `139333 / 46028 / 5413` **identici al repo** |
| B | rete rotta **+ nessuna copia locale** | muore nominando l'include e la URL | ✅ muore, **codice di uscita 1** verificato |
| C | rete rotta **ma copie locali gia' scaricate** | ripiego, 3 su 3 | ✅ `(download fallito ... : uso la copia locale gia' scaricata)` x3 |
| D | terminale **gia' popolato**, seconda passata sopra | non rompe niente | ✅ 3 file, **md5 identici** al repo prima e dopo |
| E1 | log MetaEditor **UTF-16** col nome atteso | stampa le righe leggibili | ✅ stampate, `error 133: cannot open include file` leggibile |
| E2 | **nessun** log | lo dice invece di tacere | ✅ `NESSUN LOG TROVATO in ... (metaeditor potrebbe non essere nemmeno partito)` |
| E3 | log ASCII con **nome diverso** | ripiego sul `.log` piu' recente | ✅ trovato e stampato |

### (d) 🌐 Le cinque URL al pin, provate davvero

```
200  65788  backtest_pipeline/walkforward_generico.ps1
200  24404  backtest_pipeline/righe/RIGA_ANCORA_R119.ps1
200 139333  mql5/Include/ABTG_PausaGuardian.mqh
200  46028  mql5/Include/ABTG/ABTG_ApertureCore.mqh
200   5413  mql5/Include/OptFrame.mqh
```

E il blocco `1-bis` girato con `$RawBase` = **il pin del commit**: `PRONTI=3`,
stessi byte. ✅

---

## ⚠️ 5. QUATTRO COSE DA SAPERE — dichiarate, non nascoste

1. 🔴 **Non e' provato che il round giri.** E' provato che gli include
   arrivano, che la struttura e' giusta e che il messaggio di morte parla.
   **Che l'`.ex5` si compili si vedra' solo sul VPS**, perche' qui non c'e'
   metaeditor. Se fallisse ancora, adesso il log lo dice.
2. **Con `-SoloControllo` gli include vengono SCARICATI ma NON copiati**: il
   ramo `-SoloControllo` esce alla fine del punto 6 (r.722), cioe' **dopo** il
   blocco `1-bis` (r.283) ma **prima** della copia (r.919-941). Il giro a vuoto
   stampa `include nostri pronti: 3 su 3` e nient'altro: **non e' la prova che
   il terminale li abbia**.
3. **Gli altri due `.mqh` si portano anche se oggi non servono.** E' una scelta
   dichiarata: costano un download, e il giorno che un EA tornera' a includerli
   non si ripetera' questa serata. Se domani uno dei tre sparisse dal repo, il
   driver **non** morirebbe per `ApertureCore`/`OptFrame` (`Serve=$false`) ma
   **morirebbe** per `PausaGuardian` (`Serve=$true`), che e' l'unico vero.
4. **Resta aperta la guardia "MT5 aperto" globale del driver (classe 159).**
   Non e' materia di questo lavoro e non e' stata toccata: la guardia
   chirurgica la fa `RIGA_ANCORA_R119.ps1`, che chiude **solo** i processi
   sotto `C:\MT5_Backtest` e passa `-Force` al driver.

---

## 🚀 6. LA RIGA DI LANCIO DELL'ANCORA — pronta, col pin

> 🖥️ **TERMINALE: conto demo 50504400, cartella programma `C:\MT5_Backtest`.**
> **NON e' il piccolo 50503392** (`BCM Markets MT5 Terminal`), **NON e' il
> 100k 50504263** (`... -V3`), **NON e' il REALE 10105439** (`C:\BCM_Reale`).
> La riga stampa **PID + titolo + percorso** di tutti i terminal64 vivi
> **prima** di partire: si legge quella stampa, non si riconosce la finestra a
> occhio. `-ChiudiBacktest` chiude **solo** i processi il cui `Path` sta sotto
> `C:\MT5_Backtest`: gli altri tre restano vivi, e lo script li **riconta dopo**.

```powershell
$pin="3447eb24c45101f16e6448b563aa4af039e63db0"; $w="$env:USERPROFILE\abtg_ancora"; $r="$w\RIGA_ANCORA_R119.ps1"; $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin";
New-Item -ItemType Directory -Force -Path $w | Out-Null;
Remove-Item $r -ErrorAction SilentlyContinue;
irm "$b/backtest_pipeline/righe/RIGA_ANCORA_R119.ps1?cb=$(New-Guid)" -OutFile $r -ErrorAction Stop;
if(-not (Test-Path $r)){ throw 'DOWNLOAD FALLITO' };
if(-not (Select-String -Path $r -SimpleMatch -Pattern 'MARCATORE_RIGA_ANCORA_R119_v3' -Quiet)){ throw 'RIGA VECCHIA: manca il marcatore v3, non cercherebbe il driver v5' };
Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path | Format-Table -AutoSize;
& powershell -NoProfile -ExecutionPolicy Bypass -File $r -Pin $pin -TerminaleBacktest "C:\MT5_Backtest" -ChiudiBacktest
```

**Sintassi verificata col parser: `RIGA ANCORA: SINTASSI OK`. ASCII puro.**

### Perche' il `-Pin` va passato

`RIGA_ANCORA_R119.ps1` costruisce il suo `$RawBase` da `-Pin` e da li' scarica
**il driver**, che a sua volta da li' scarica **EA e include**. Passando lo
**stesso sha** a tutti e tre i livelli, la corsa gira su **un solo commit
congelato**: niente "una copia vecchia ha rifatto la griglia sbagliata"
(10/08). Con `-Pin lavoro` funzionerebbe uguale, ma non sarebbe congelato.

### La raccolta e' gia' dentro lo script (regola delle righe di lancio, punti 2 e 3)

`RIGA_ANCORA_R119.ps1` scrive **da solo** sul Desktop del VPS:

```
Desktop\ANCORA_R119\        <- cartella
Desktop\ANCORA_R119.zip     <- lo zip pronto da mandare
```

**I 7 file attesi dentro:**

```
REFERTO_ANCORA_R119.txt
ABTG_ORB_Ottimizzato_U30USD_IS_ANCORA.csv
ABTG_ORB_Ottimizzato_U30USD_OOS_ANCORA.csv
ABTG_DAX_Apertura_EU_D30EUR_IS_ANCORA.csv
ABTG_DAX_Apertura_EU_D30EUR_OOS_ANCORA.csv
ABTG_ORB_Ottimizzato_RITARDO.txt
ABTG_DAX_Apertura_EU_RITARDO.txt
```

### 🎯 I numeri che devono uscire (invariati, dal referto R119 del 07/09)

| sedia | Profit | PF | DD % | Trade |
|---|---|---|---|---|
| ORB `U30USD` | **2484,17** | **1,67490** | **6,5389** | **119** |
| DAX `D30EUR` | **1103,31** | **1,41105** | **4,3501** | **270** |

### 👀 Cosa guardare a schermo, in ordine

1. `MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE` — se dice v4, e' una copia vecchia.
2. `tetto barre: MaxBars=...` — dev'essere sufficiente (10.000.000 la scorsa volta).
3. `--- TERMINALE SCELTO ---` con `via: parametro esplicito -TerminaleBacktest`.
4. 🆕 `--- INCLUDE NOSTRI PORTATI SUL TERMINALE ---` con **`ABTG_PausaGuardian.mqh 139333 byte`**.
   **Se questa riga non c'e', il driver e' vecchio e il round morira' come ieri.**
5. `compilato ABTG_ORB_Ottimizzato` in verde — la riga che ieri non e' mai uscita.
6. Alla fine `ESITO: ANCORA SUPERATA`, e i PID non bersaglio **identici** prima e dopo.

---

## 📌 IN UNA RIGA

**Diagnosi confermata:** il driver portava l'EA ma non il file che l'EA
include, e su un terminale nuovo e vuoto quello e' un round morto in due
secondi. Adesso porta **tutti e tre** gli `.mqh` nostri, **lo dice a schermo**,
e se la compilazione fallisce lo stesso **stampa il log invece di alzare le
spalle**. 🎯
