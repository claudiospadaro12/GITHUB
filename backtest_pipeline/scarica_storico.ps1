# =====================================================================
#  scarica_storico.ps1  --  scarica lo STORICO dal broker e dice
#                           SE il broker ce l'ha davvero
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (walk-forward del 05/08/2026):
#  la finestra IS 2024.01-2025.06 produceva 10,0 trade/mese contro i
#  20,4 della OOS, con rapporto 2,03 IDENTICO su D30EUR e NASUSD (e lo
#  stesso segno gia' visto sul Dow). Un EA che fa al massimo 1 trade al
#  giorno, su ~21 giorni di borsa al mese, deve stare intorno a 20.
#  Quindi meta' dei giorni del 2024 NON C'E'. Finche' non e' risolto,
#  nessun confronto IS->OOS e' un test di overfitting valido.
#
#  COSA FA:
#   1. installa e compila ABTG_HistoryDownloader nel terminale BCM
#   2. (con -Auto) lancia MT5 che esegue lo script da solo
#   3. rilegge MQL5\Files\ABTG_StoricoScaricato.csv e stampa il verdetto
#
#  LA COLONNA CHE CONTA e' l'ultima:
#   COMPLETO                      -> a posto, si puo' testare da li'
#   MANCA STORICO LOCALE          -> e' solo da scaricare, rilancia
#   IL BROKER NON HA PIU' STORICO -> inutile insistere: si SPOSTA la
#                                    finestra di test, non si scarica
#
#  COME SI LANCIA (PC di backtest, il repo NON e' clonato):
#   irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scarica_storico.ps1" -OutFile "$env:USERPROFILE\scarica_storico.ps1"
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\scarica_storico.ps1" -Auto
#
#  VARIANTI (si aggiungono in coda alla seconda riga)
#   -Auto                     fa tutto da solo (richiede MT5 CHIUSO)
#   (niente -Auto)            installa e stampa le istruzioni manuali
#   -Da 2022.01.01            prova a risalire piu' indietro
#   -Simboli "XAUUSD"         altri simboli
#   -SenzaTick                solo barre, niente tick reali (molto piu' veloce)
#   -SoloReferto              rilegge l'ultimo risultato senza rifare nulla
#
#  !! SUL VPS NON USARE -Auto: chiuderebbe il terminale che tiene su
#     gli EA in forward. Sul VPS: installa e trascina lo script a mano.
# =====================================================================
param(
  [string] $Simboli    = "D30EUR,NASUSD,U30USD",
  [string] $Da         = "2023.01.01",
  [string] $Timeframes = "M1,M5,M15,M30,H1,H4,D1",
  [switch] $SenzaTick,
  [switch] $Auto,
  [switch] $ChiudiMT5,
  [switch] $SoloReferto,
  [int]    $TimeoutMin = 90
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Il sorgente .mq5 si prende da GitHub, come fanno gli altri driver: sul PC
# di backtest il repo NON e' clonato, si scarica un .ps1 alla volta.
# Se invece il repo c'e' (es. sul PC di sviluppo) si usa la copia locale.
$EABranch = "lavoro"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Work     = Join-Path $env:USERPROFILE "abtg_storico"
New-Item -ItemType Directory -Force -Path $Work | Out-Null

# ---------------------------------------------------------------------
# 1. trova terminale BCM + cartella dati
# ---------------------------------------------------------------------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }

$instDir    = $cand.DirectoryName
$Terminal   = Join-Path $instDir "terminal64.exe"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }

$CsvOut = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"

# ---------------------------------------------------------------------
# funzione: rilegge il CSV e stampa il referto
# ---------------------------------------------------------------------
# legge il CSV anche se MT5 lo tiene ancora aperto (lettura condivisa,
# copia in temp, e in ultima istanza rinuncia senza far morire lo script)
function Leggi-Csv {
  if (-not (Test-Path $CsvOut)) { return $null }
  try {
    $fs = [System.IO.File]::Open($CsvOut, 'Open', 'Read', 'ReadWrite')
    $sr = New-Object System.IO.StreamReader($fs)
    $testo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    if ([string]::IsNullOrWhiteSpace($testo)) { return $null }
    return ($testo | ConvertFrom-Csv)
  } catch {
    try {
      $tmp = Join-Path $env:TEMP "abtg_storico_peek.csv"
      Copy-Item $CsvOut $tmp -Force -ErrorAction Stop
      return (Import-Csv $tmp)
    } catch { return $null }
  }
}

function Mostra-Referto {
  $righe = Leggi-Csv
  if (-not $righe) {
    Write-Host "`nNessun referto leggibile in:`n  $CsvOut" -ForegroundColor Yellow
    Write-Host "O lo script non e' ancora stato eseguito, o MT5 lo sta ancora scrivendo:" -ForegroundColor Yellow
    Write-Host "chiudi MT5 e rilancia con -SoloReferto." -ForegroundColor Yellow
    return
  }
  Write-Host "`n=== REFERTO STORICO ===" -ForegroundColor Cyan
  Write-Host ("{0}" -f $CsvOut) -ForegroundColor DarkGray
  $righe | Format-Table Simbolo, Timeframe, Barre, PrimaDataLocale, PrimaDataServer, Verdetto -AutoSize

  $bloccati = $righe | Where-Object { $_.Verdetto -like "*NON HA PIU'*" }
  $daRifare = $righe | Where-Object { $_.Verdetto -like "*MANCA STORICO*" }
  if ($bloccati) {
    Write-Host "!! IL BROKER NON HA PIU' STORICO su queste righe:" -ForegroundColor Red
    $bloccati | ForEach-Object { Write-Host ("   {0} {1} -> parte dal {2}" -f $_.Simbolo, $_.Timeframe, $_.PrimaDataServer) -ForegroundColor Red }
    Write-Host "   Non si scarica quello che non esiste: si SPOSTA la finestra IS" -ForegroundColor Red
    Write-Host "   alla prima data disponibile e si rifa' il walk-forward da li'." -ForegroundColor Red
  }
  if ($daRifare) {
    Write-Host "!! Manca solo il download su queste righe: rilancia lo script." -ForegroundColor Yellow
    $daRifare | ForEach-Object { Write-Host ("   {0} {1}" -f $_.Simbolo, $_.Timeframe) -ForegroundColor Yellow }
  }
  if (-not $bloccati -and -not $daRifare) {
    Write-Host "OK: storico completo su tutte le righe. Si puo' rifare la fase IS." -ForegroundColor Green
  }
}

if ($SoloReferto) { Mostra-Referto; exit 0 }

# ---------------------------------------------------------------------
# 2. installa + compila lo script
# ---------------------------------------------------------------------
Write-Host "=== SCARICO STORICO: $Simboli  (da $Da) ===" -ForegroundColor Cyan

$Locale = Join-Path $RepoRoot "..\mql5\Scripts\ABTG_HistoryDownloader.mq5"
if (Test-Path $Locale) {
  $Src = $Locale
  Write-Host "  sorgente:  repo locale" -ForegroundColor DarkGray
} else {
  $Src = Join-Path $Work "ABTG_HistoryDownloader.mq5"
  try {
    Invoke-WebRequest -Uri "$RawBase/mql5/Scripts/ABTG_HistoryDownloader.mq5" -OutFile $Src -UseBasicParsing
    Write-Host "  sorgente:  scaricato da GitHub ($EABranch)" -ForegroundColor DarkGray
  } catch {
    Write-Host "ERRORE: non riesco a scaricare ABTG_HistoryDownloader.mq5 da GitHub." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
  }
}
$DstDir = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
Copy-Item $Src -Destination $DstDir -Force
$mq5 = Join-Path $DstDir "ABTG_HistoryDownloader.mq5"
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($mq5, ".ex5")
if (-not (Test-Path $ex5)) { Write-Host "ERRORE di compilazione." -ForegroundColor Red; exit 1 }
Write-Host "  compilato: ABTG_HistoryDownloader.ex5" -ForegroundColor Green

# ---------------------------------------------------------------------
# 3. preset con i parametri
# ---------------------------------------------------------------------
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$SetFile = Join-Path $PresetDir "abtg_storico.set"
$tick = if ($SenzaTick) { "false" } else { "true" }
@"
InpSimboli=$Simboli
InpTimeframes=$Timeframes
InpDataInizio=$Da
InpListaSoloNomi=false
InpTuttiBroker=false
InpTimeoutSec=120
InpScaricaTick=$tick
"@ | Set-Content -Path $SetFile -Encoding ASCII
Write-Host "  preset:    MQL5\Presets\abtg_storico.set" -ForegroundColor Green

# ---------------------------------------------------------------------
# 4a. modalita' MANUALE (default, e l'unica ammessa sul VPS)
# ---------------------------------------------------------------------
if (-not $Auto) {
  Write-Host @"

--- ORA IN MT5 (2 minuti) ---------------------------------------------
 1. Strumenti > Opzioni > Grafici > "Max barre nel grafico" = ILLIMITATO
    (e' il tappo numero uno: senza questo il download si ferma da solo)
 2. Navigatore > Script > tasto destro > Aggiorna
 3. Trascina ABTG_HistoryDownloader su un grafico qualsiasi
 4. Nella finestra parametri: Carica > abtg_storico.set
    (contiene gia' InpSimboli=$Simboli e InpDataInizio=$Da)
 5. OK. Guarda la scheda ESPERTI (non Journal). I tick reali su piu'
    anni possono richiedere parecchi minuti: lascialo finire.
 6. Poi torna qui e lancia:
       powershell -ExecutionPolicy Bypass -File "`$env:USERPROFILE\scarica_storico.ps1" -SoloReferto
-----------------------------------------------------------------------
"@ -ForegroundColor Yellow
  Mostra-Referto
  exit 0
}

# ---------------------------------------------------------------------
# 4b. modalita' AUTOMATICA (solo PC di backtest, MT5 chiuso)
# ---------------------------------------------------------------------
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running -and $ChiudiMT5) {
  Write-Host "`nMT5 e' aperto: lo chiudo (-ChiudiMT5)." -ForegroundColor Yellow
  $running | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 5
  $running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
}
if ($running) {
  Write-Host "`nMT5 e' APERTO. In automatico non si puo': un secondo avvio" -ForegroundColor Red
  Write-Host "sulla stessa cartella dati non esegue lo script." -ForegroundColor Red
  Write-Host "Aggiungi -ChiudiMT5 per farlo chiudere da solo, oppure usa la" -ForegroundColor Red
  Write-Host "modalita' manuale (senza -Auto)." -ForegroundColor Red
  Write-Host "SUL VPS: NON usare -ChiudiMT5, spegneresti gli EA in forward." -ForegroundColor Red
  exit 1
}

if (Test-Path $CsvOut) { Remove-Item $CsvOut -Force }   # cosi' so che il referto e' nuovo

$primoSym = ($Simboli -split ",")[0].Trim()
$Ini = Join-Path $env:TEMP "abtg_storico.ini"
# --- 21/08/2026 - [Experts] AllowLiveTrading=false: NON e' cosmetica, ed e'
#  la stessa riga che walkforward_generico.ps1 porta con dodici righe di
#  commento sopra. Il motivo e' identico e vale ANCHE qui:
#  /config NON apre un tester. Apre IL TERMINALE, che carica l'ultimo
#  profilo con i suoi grafici e gli EA attaccati sopra. Sul PC di backtest
#  quel terminale e' collegato al conto VIVO 50503392: senza questa riga,
#  scaricare lo storico RIARMA di fatto gli EA su grafico, che piazzano
#  ordini veri. E' successo il 14/08 (un DAX Apertura partito in breakout
#  da un grafico M3 di prova).
#  Qui morde di piu' che altrove, perche' questo script gira per PRIMO:
#  e' il PASSO 0 dei round, cioe' il gesto piu' innocuo della serata.
#  Il download dello storico non ne risente: lo fa uno Script, che non
#  passa dal permesso di trading dal vivo.
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_storico.set
Symbol=$primoSym
Period=M5
"@ | Set-Content -Path $Ini -Encoding Unicode

Write-Host "`nAvvio MT5 in automatico (timeout $TimeoutMin min)..." -ForegroundColor Cyan
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

# Attesa: si guarda SOLO la dimensione del file, mai il contenuto.
# (la prima versione faceva Import-Csv qui dentro e moriva con
#  "il file e' in uso da un altro processo", lasciando MT5 aperto)
$ErrorActionPreference = "Continue"

# --- fotografia dei log PRIMA di partire: cosi' dopo si legge solo il nuovo
$logDirW  = Join-Path $DataFolder "MQL5\Logs"
$lenPrima = @{}
if (Test-Path $logDirW) {
  foreach ($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)) {
    $lenPrima[$f.FullName] = $f.Length
  }
}
function Coda-Log-Storico {
  # Legge SOLO cio' che i log hanno scritto DOPO la fotografia $lenPrima.
  # DIFETTO PAGATO (18/08 sera, PASSO 0 di R84): la prima versione, quando
  # un file NON era cresciuto (il log di IERI), saltava il Seek per la
  # condizione "$da -lt Length" e lo RILEGGEVA DA CAPO: il "=== FINITO"
  # della corsa di ieri sera e' stato preso per quello di oggi, MT5 e'
  # stato ammazzato dopo 15 secondi col download appena partito, CSV da
  # 0 byte. Regola: file non cresciuto = NIENTE da leggere, si salta.
  if (-not (Test-Path $logDirW)) { return "" }
  $tutto = ""
  foreach ($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)) {
    $da = 0
    if ($lenPrima.ContainsKey($f.FullName)) { $da = [int64]$lenPrima[$f.FullName] }
    if ($da % 2 -ne 0) { $da = $da - 1 }
    try {
      $fs = New-Object System.IO.FileStream($f.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
      if ($da -ge $fs.Length) { $fs.Close(); continue }
      if ($da -gt 0) { [void]$fs.Seek($da, [System.IO.SeekOrigin]::Begin) }
      $sr = New-Object System.IO.StreamReader($fs, [System.Text.Encoding]::Unicode, $false)
      $tutto = $tutto + $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    } catch { }
  }
  return $tutto
}

$scaduto = (Get-Date).AddMinutes($TimeoutMin)
$ultimaLen  = -1
$fermoDa    = 0
$visto      = $false
$finito     = $false
$faseTick   = $false
while ((Get-Date) -lt $scaduto) {
  Start-Sleep -Seconds 15

  # --- HA FINITO DAVVERO? -------------------------------------------
  #  IL SILENZIO NON E' UN SEGNALE DI FINE (imparato il 15/08/2026).
  #  Questo script trattava 60 secondi di silenzio come "ha finito". Ma
  #  il downloader, sul PRIMO simbolo, chiede al server anni di barre e
  #  di tick: sta zitto per minuti prima di scrivere la prima riga. Il
  #  15/08 e' partito QUATTRO volte e ogni volta e' stato ammazzato dopo
  #  la sola riga di intestazione, lasciando un CSV da ZERO byte.
  #  E' lo stesso difetto gia' corretto in prepara_broker_esterno.ps1:
  #  il segnale buono e' la riga di chiusura che lo script MQL5 stampa
  #  da solo. Il silenzio resta solo come rete, e molto piu' lungo.
  $coda = Coda-Log-Storico
  if ($coda -match "=== FINITO") {
    Write-Host "  lo script ha stampato la sua riga di chiusura: ha finito." -ForegroundColor Green
    $visto = $true
    $finito = $true
    break
  }
  if ($coda -match "ABTG_HistoryDownloader") { $visto = $true }

  # --- FASE TICK: il CSV NON CRESCE PER ORE ---------------------------
  #  DIFETTO PAGATO (classe 30 della checklist, 20/08): la riga TICK del
  #  CSV la scrive ABTG_HistoryDownloader.mq5 (righe 219-232) SOLO quando
  #  DownloadTicks ha finito. Fra "TICK : scarico..." e "=== FINITO" il
  #  file resta della STESSA lunghezza anche per ore: il guardiano dei 15
  #  minuti qui sotto ammazzerebbe MT5 in mezzo allo scaricamento dei
  #  tick, e il referto uscirebbe SENZA la riga TICK, con codice 0.
  #  Durante la fase tick l'unico limite ammesso e' -TimeoutMin.
  if ($coda -match "TICK : scarico") { $faseTick = $true }

  if (-not (Test-Path $CsvOut)) { continue }
  $visto = $true
  $len = 0
  try { $len = (Get-Item $CsvOut -ErrorAction Stop).Length } catch { continue }
  if ($len -eq $ultimaLen) {
    if ($faseTick) { continue }   # vedi sopra: qui il silenzio e' NORMALE
    $fermoDa += 15
    if ($fermoDa -ge 900) {               # 15 minuti, non 1
      Write-Host "  fermo da 15 minuti senza riga di chiusura: mi fermo qui." -ForegroundColor Yellow
      Write-Host "  ATTENZIONE: il referto potrebbe essere INCOMPLETO." -ForegroundColor Yellow
      break
    }
  } else {
    $fermoDa = 0
    $ultimaLen = $len
    Write-Host ("  ... {0} byte scritti" -f $len) -ForegroundColor DarkGray
  }
}
$ErrorActionPreference = "Stop"

if (-not $visto) {
  Write-Host "`nTimeout: nessun referto prodotto." -ForegroundColor Red
  Write-Host "Controlla la scheda ESPERTI di MT5, poi riprova in manuale (senza -Auto)." -ForegroundColor Red
  exit 1
}

Write-Host "`nChiudo MT5..." -ForegroundColor DarkGray
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Mostra-Referto

# =====================================================================
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio, punto 2)
# ---------------------------------------------------------------------
#  MANCAVA, e il 15/08 e' costata a Claudio una caccia al file: il
#  referto finiva SOLO in <cartella dati>\MQL5\Files, cioe' sepolto
#  sotto %APPDATA%\MetaQuotes\Terminal\<codice lunghissimo>. Tutti gli
#  altri script del progetto raccolgono sul Desktop e fanno lo zip:
#  questo no. Adesso si'.
# =====================================================================
try {
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  if (Test-Path $CsvOut) { Copy-Item $CsvOut $dest -Force }
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDir) {
    Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
      ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
  }
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm.zip"
  try { Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force } catch { }
  Write-Host ""
  Write-Host ("RACCOLTA: " + $dest) -ForegroundColor Green
  Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
  Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
  Write-Host "   - ABTG_StoricoScaricato.csv" -ForegroundColor DarkGray
  Write-Host "   - gli ultimi 2 log di MT5 (*.log)" -ForegroundColor DarkGray
} catch {
  Write-Host ("La raccolta sul Desktop non e' riuscita: " + $_.Exception.Message) -ForegroundColor Yellow
  Write-Host ("Il referto resta comunque qui: " + $CsvOut) -ForegroundColor Yellow
}

Write-Host ""
Write-Host "La colonna che serve e' PrimaDataServer: e' la data VERA da cui" -ForegroundColor Cyan
Write-Host "parte lo storico, quella da passare a -DaQuando." -ForegroundColor Cyan
Write-Host "(sulle righe TICK PrimaDataServer vale sempre '-': li' si legge PrimaDataLocale)" -ForegroundColor Cyan

# --- UN TIMEOUT NON PUO' USCIRE 0 (checklist punto 19.2) -------------
#  Se "=== FINITO" non e' mai arrivato, MT5 e' stato fermato a meta':
#  il referto qui sopra e' PARZIALE. Si esce 2 DOPO la raccolta, cosi'
#  l'artefatto c'e' lo stesso e chi chiama decide (checklist 26-bis).
if (-not $finito) {
  Write-Host ""
  Write-Host "ATTENZIONE: la riga di chiusura '=== FINITO' non e' mai arrivata." -ForegroundColor Red
  Write-Host "MT5 e' stato fermato dal timeout: IL REFERTO E' PARZIALE." -ForegroundColor Red
  exit 2
}
