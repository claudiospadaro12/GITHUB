# 🚀 RIGA DI LANCIO — SONDA MEDIAZIONE (conteggio dei PACCHETTI)

**Pin: `13db8c9a4f214faf975f9ee998d71b7e0de506c0`** (branch `lavoro`, 21/08/2026).
Referto: `backtest_pipeline/risultati_archivio/SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md`.
Firma che l'autorizza: `report/NODO_MEDIAZIONE_2026-08-21.md`, **opzione C "frequenza"**.

> 🛑 **Cosa NON fa questa riga:** non apre nessun ordine, non lancia nessuna
> ottimizzazione, non tocca il forward, non installa nessun EA. Installa **uno
> Script** che legge storico e conta. Il PASSO 1 **si rifiuta di installarlo**
> se nel sorgente compare una chiamata di trading.
>
> ⏱️ **Costo:** PASSO 0 minuti-decine di minuti (dipende dal broker), PASSO 1
> ~1 minuto, PASSO 2 pochi secondi di corsa, PASSO 3 istantaneo.
>
> 🧊 **Non scavalca la coda.** Il PC di backtest ha **un solo MT5**: se sta
> girando R93/R94, questa sonda aspetta. Il PASSO 0 pretende **MT5 chiuso**
> (usa `-Auto`), il PASSO 1 e il 3 no.

---

## PASSO 0 — LO STORICO H1 DEI TRE CROSS (MT5 CHIUSO)

Senza storico il conteggio misura il nulla, ed e' il canarino n.1 del referto.
`-SenzaTick` perche' la sonda legge **solo barre**: i tick qui non servono e
costerebbero ore.

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -ErrorAction SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, -Auto lo pilota lui" }
  $h="13db8c9a4f214faf975f9ee998d71b7e0de506c0"
  $p="$env:USERPROFILE\scarica_storico.ps1"
  Remove-Item $p -Force -ErrorAction SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scarica_storico.ps1" -OutFile $p -ErrorAction Stop
  & powershell -ExecutionPolicy Bypass -File $p -Auto -SenzaTick -Da 2010.01.01 -Timeframes "H1" -Simboli "EURUSD,GBPUSD,EURGBP"
  if($LASTEXITCODE -ne 0){ throw ("scarica_storico uscito con codice " + $LASTEXITCODE) }
}
```

**Cosa si legge:** l'ultima colonna del referto, **riga per riga**.
`COMPLETO` = si puo' contare da li'. Se per un cross la data d'inizio e' **dopo
il 2010.01.01**, quel cross conta su **mezza finestra**: va scritto nel referto
e il suo numero **non si somma agli altri come se fossero pari**.
**Raccolta: la fa lo script da solo** -> `Desktop\storico_bcm.zip`.

---

## PASSO 1 — INSTALLA E COMPILA LA SONDA (MT5 puo' restare aperto)

Scarica il sorgente **dal pin**, verifica il **marcatore di versione** (contro la
cache di `raw`, ~5 minuti), **rifiuta il file se contiene chiamate di trading**,
lo copia in `MQL5\Scripts` e lo compila **da riga di comando** (non chiedendo a
Claudio di premere F7 su un file che sulla sua macchina non c'e' ancora).

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $h="13db8c9a4f214faf975f9ee998d71b7e0de506c0"
  $src="$env:USERPROFILE\ABTG_SondaMediazione.mq5"
  Remove-Item $src -Force -ErrorAction SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/mql5/Scripts/ABTG_SondaMediazione.mq5" -OutFile $src -ErrorAction Stop
  if(-not (Select-String -Path $src -SimpleMatch -Pattern "SONDA DI FREQUENZA - conta PACCHETTI" -Quiet)){ throw "sorgente VECCHIO o troncato (cache di raw): riprova fra 5 minuti" }
  if(Select-String -Path $src -Pattern "OrderSend|CTrade|PositionClose|PositionOpen|MqlTradeRequest" -Quiet){ throw "IL FILE CONTIENE CHIAMATE DI TRADING: non si installa" }
  if(Select-String -Path $src -Pattern "^#include|^#import" -Quiet){ throw "IL FILE HA UNA DIPENDENZA ESTERNA: nessun driver la installa (checklist 33-bis)" }
  $t=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $t){ throw "terminale BCM non trovato" }
  $me=Join-Path $t.DirectoryName "metaeditor64.exe"
  if(-not (Test-Path $me)){ throw "metaeditor64.exe non trovato accanto al terminale" }
  $root=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $data=Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $t.DirectoryName) } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $data){ throw "cartella dati del terminale non trovata" }
  $dst=Join-Path $data "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  $mq=Join-Path $dst "ABTG_SondaMediazione.mq5"
  Copy-Item $src $mq -Force
  $ex=[System.IO.Path]::ChangeExtension($mq,".ex5")
  Remove-Item $ex -Force -ErrorAction SilentlyContinue
  & $me "/compile:$mq" "/log" | Out-Null
  if(-not (Test-Path $ex)){ Get-Content ([System.IO.Path]::ChangeExtension($mq,".log")) -ErrorAction SilentlyContinue | Select-Object -Last 40; throw "COMPILAZIONE FALLITA: sopra ci sono le ultime righe del log" }
  Write-Host ("OK compilato -> " + $ex)
  Write-Host ("sorgente installato: " + (Get-Item $mq).Length + " byte  (deve coincidere col repo)")
  Write-Host ("cartella dati: " + $data)
}
```

**Cosa si legge, e sono tre cose:** `OK compilato` · **zero** righe di errore del
compilatore · la **lunghezza in byte** del sorgente installato (punto 27-ter: la
guardia guarda il contenuto, non il nome). Se una delle tre non torna, **non si
va avanti**.

---

## PASSO 2 — LA CORSA (a mano, ed e' spiegato perche')

Uno Script si esegue **trascinandolo su un grafico**: non esiste un driver che lo
faccia partire senza pilotare il terminale, e pilotare il terminale del PC di
backtest mentre e' aperto e' esattamente il gesto che la checklist vieta.

1. In MT5: **Navigatore → Script → tasto destro → Aggiorna**. Deve comparire
   **`ABTG_SondaMediazione`** (se non c'e', il PASSO 1 non e' andato).
2. Trascinalo su **un grafico qualsiasi** (il simbolo e il TF del grafico **non
   contano**: i dati li legge lui, cross per cross, su H1).
3. Nella finestra degli input **lascia tutto com'e'** e premi **OK**.
   I default sono gia' quelli firmati: `EURUSD=40,GBPUSD=70,EURGBP=20`,
   `InpTF = H1`, `InpDa = 2010.01.01`, `InpAutoTest = true`.
   *(Se i simboli del broker avessero un suffisso, si mette in `InpSuffisso`.)*
4. **Guarda la scheda ESPERTI** (non il Giornale).

**Cosa DEVE esserci, in quest'ordine:**

| # | riga attesa | se manca |
|---|---|---|
| 1 | `[MEDIAZIONE][AUTOTEST] geometria: 21 valori su 21 = PASS` | **si ferma da solo**: la geometria non riproduce il corso, non c'e' niente da leggere |
| 2 | un blocco per **ciascuno** dei 3 cross, con `barre lette` **intorno a 90.000** su H1 dal 2010 | sotto ~20.000 = **manca lo storico** -> rifai il PASSO 0 |
| 3 | `finestra EFFETTIVA : ... -> ...` | e' la finestra **vera**, l'unica che va citata nel referto |
| 4 | `>>> PACCHETTI TOTALI : N <<< IL NUMERO DELLA FIRMA` | e' il numero. **Non e' un giudizio: e' un conteggio** |
| 5 | `istogramma LIVELLI` e `pacchetti PIENI ... %` | se sotto il **5%**, lo script stampa da solo `CODA SOTTO-CAMPIONATA` (G3.1) |
| 6 | `PACCHETTI PER ANNO` + `per arrivare a 150 pacchetti servono gli ULTIMI n anni` | e' il materiale per **dimensionare l'IS** (Emendamento A) |

> ⚠️ **Il numero che conta e' UNO SOLO: `PACCHETTI`.** `segnali validi grezzi` e'
> **piu' alto** ed e' stampato apposta per trasparenza, **ma non e' il numero
> della firma**: un segnale che cade mentre il pacchetto precedente e' ancora
> vivo non e' un evento indipendente (assunzione A4, referto §2).

---

## PASSO 3 — RACCOLTA (subito dopo la corsa)

Controlla che i due CSV **esistano e siano FRESCHI** (non l'artefatto di un'altra
corsa), **riconta i pacchetti dal file** invece di fidarsi della stampa, copia
tutto sul Desktop e crea lo zip.

```powershell
& {
  $t=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $t){ throw "terminale BCM non trovato" }
  $root=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $data=Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $t.DirectoryName) } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $data){ throw "cartella dati del terminale non trovata" }
  $tot=Join-Path $data "MQL5\Files\ABTG_SondaMediazione.csv"
  $pac=Join-Path $data "MQL5\Files\ABTG_SondaMediazione_pacchetti.csv"
  foreach($f in @($tot,$pac)){
    if(-not (Test-Path $f)){ throw ("MANCA " + $f + " : lo script non e' stato eseguito") }
    $eta=((Get-Date)-(Get-Item $f).LastWriteTime).TotalHours
    if($eta -gt 6){ throw ("ARTEFATTO VECCHIO: " + $f + " e' del " + (Get-Item $f).LastWriteTime + " -- e' di un'altra corsa") }
  }
  $righe=(Get-Content $pac | Measure-Object -Line).Lines - 1
  $rigaTot=Import-Csv $tot -Delimiter ";" | Where-Object { $_.simbolo -eq "TOTALE" } | Select-Object -First 1
  if(-not $rigaTot){ throw "il CSV dei totali non ha la riga TOTALE: file troncato" }
  $dichiarati=[int]$rigaTot.PACCHETTI
  Write-Host ("PACCHETTI dichiarati nel CSV totali : " + $dichiarati)
  Write-Host ("righe nel CSV per-pacchetto         : " + $righe)
  if($dichiarati -ne $righe){ throw "I DUE CONTEGGI NON COINCIDONO: il numero non si usa finche' non si capisce perche'" }
  $dest=Join-Path ([Environment]::GetFolderPath("Desktop")) ("sonda_mediazione_" + (Get-Date -Format "yyyy-MM-dd"))
  Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item $tot $dest -Force
  Copy-Item $pac $dest -Force
  $log=Get-ChildItem (Join-Path $data "MQL5\Logs") -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if($log){ Copy-Item $log.FullName (Join-Path $dest ("esperti_" + $log.Name)) -Force } else { Write-Host "ATTENZIONE: log Esperti non trovato" }
  $zip=$dest + ".zip"
  Remove-Item $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Get-ChildItem $dest | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Write-Host ("ZIP PRONTO DA MANDARE -> " + $zip)
}
```

**Numeri attesi, dichiarati PRIMA di guardarli:**
- nella cartella: **3 file** (`ABTG_SondaMediazione.csv`,
  `ABTG_SondaMediazione_pacchetti.csv`, `esperti_*.log`);
- `PACCHETTI dichiarati` **deve essere identico** a `righe nel CSV per-pacchetto`
  — se non lo e', il blocco **si ferma** e il numero **non si usa**;
- lo zip esiste e **non e' vuoto**.

> 🧭 **Nota sulla data del log** (checklist punto 29): il log Esperti si prende
> **il piu' recente per data di modifica**, non "quello di oggi": una corsa fatta
> alle 23:58 finirebbe nel file di ieri.
> 🌍 **Nessun numero decimale viene letto o scritto da questi blocchi** (solo
> interi e date con pattern fisso): la trappola della cultura it-IT (punto 5)
> qui non si presenta.

---

## ✍️ E POI

Manda lo zip. Il referto di lettura si scrive **dopo**, e dira' **una cosa sola**:
se i pacchetti sono **>= 150** o **< 150**, con la **finestra effettiva** accanto.

**Non dira' se la Mediazione guadagna** (nessun P&L in tutto lo script), non
sciogliera' il **fattore 2,29**, e non dira' se una prop la ammette:
sono tre cancelli diversi, e restano tutti aperti.
