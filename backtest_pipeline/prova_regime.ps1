# =====================================================================
#  prova_regime.ps1 -- ROUND 50: le celle VIVE misurate in ALTRI REGIMI
#  (14/08/2026, richiesta di Claudio: "ci servono piu' anni, anche la
#  fase calante, per capire chi entra e chi esce")
#
#  COSA FA: prende le celle promosse (parametri CONGELATI, file
#  prove\CELLE_REGIME.txt) e le rilancia sui simboli importati _EXT
#  (2018-2024) in QUATTRO finestre di regime diverso. Nessuna griglia,
#  nessuna ottimizzazione: una cella = un risultato per finestra.
#
#  I CRITERI DI GIUDIZIO SONO CONGELATI in prove\PROVA_REGIME_CRITERI.md
#  e sono stati approvati PRIMA di vedere qualunque numero. Non si
#  spostano. Questo script produce solo i CSV: il verdetto si scrive
#  dopo, citando il criterio.
#
#  PC DI BACKTEST, MT5 CHIUSO. Mai sul VPS.
#
#  USO:
#    powershell -ExecutionPolicy Bypass -File .\prova_regime.ps1 -SoloControllo
#    powershell -ExecutionPolicy Bypass -File .\prova_regime.ps1
# =====================================================================
param(
  [string]$Celle      = "",          # default: prove\CELLE_REGIME.txt
  [string]$Suffisso   = "_EXT",      # i simboli importati
  [int]   $Modello    = 1,           # 1 = OHLC M1: i dati importati sono barre, NON tick
  [int]   $Deposito   = 100000,
  [string]$Etichetta  = "r50",
  [switch]$SoloControllo,
  [string]$Terminal   = "",[string]$MetaEditor = "",[string]$DataFolder = "",[switch]$Force
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Work = if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
$EABranch = "lavoro"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- LE QUATTRO FINESTRE (fissate nei criteri, non si toccano qui) ---
$Finestre = @(
  @{ nome="ORSO";     da="2022.01.01"; a="2022.10.31" },
  @{ nome="CROLLO";   da="2020.02.01"; a="2020.04.30" },
  @{ nome="TORO";     da="2021.01.01"; a="2021.12.31" },
  @{ nome="LATERALE"; da="2019.01.01"; a="2019.12.31" }
)

function Muori($t){ Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

# --- 1. le celle ---
if(-not $Celle){ $Celle = Join-Path $Work "prove\CELLE_REGIME.txt" }
if(-not (Test-Path $Celle)){
  try{ Invoke-WebRequest -Uri "$RawBase/backtest_pipeline/prove/CELLE_REGIME.txt" -OutFile $Celle -UseBasicParsing }
  catch{ Muori "manca il file delle celle: $Celle" }
}
$Lista = @()
foreach($riga in (Get-Content $Celle)){
  $r = $riga.Trim()
  if($r -eq "" -or $r.StartsWith("#")){ continue }
  $p = $r -split "\|"
  if($p.Count -lt 5){ Muori "riga mal formata nel file celle:`n    $r" }
  $Lista += [pscustomobject]@{
    Nome    = $p[0].Trim()
    EA      = $p[1].Trim()
    Simbolo = $p[2].Trim()
    Periodo = $p[3].Trim()
    Input   = $p[4].Trim()
  }
}
if($Lista.Count -eq 0){ Muori "nessuna cella da misurare." }

Write-Host ""
Write-Host "=== PROVA DI REGIME (R50) ===" -ForegroundColor Cyan
Write-Host ("    celle: {0}   finestre: {1}   lanci totali: {2}" -f $Lista.Count, $Finestre.Count, ($Lista.Count*$Finestre.Count)) -ForegroundColor Gray
Write-Host "    Modello $Modello (i dati importati sono BARRE: i tick reali non esistono qui)" -ForegroundColor Gray
Write-Host ""
Write-Host "    RICORDA, dai criteri congelati:" -ForegroundColor Yellow
Write-Host "     - parametri CONGELATI: nessuna ottimizzazione, mai" -ForegroundColor Yellow
Write-Host "     - il confronto e' DENTRO questo feed (ORSO vs TORO), mai contro BCM" -ForegroundColor Yellow
Write-Host "     - un long-only che non guadagna nell'orso NON e' bocciato:" -ForegroundColor Yellow
Write-Host "       si guarda che non si distrugga (DD) e che non sanguini (PF>=0,90)" -ForegroundColor Yellow
Write-Host ""
foreach($c in $Lista){
  Write-Host ("    {0,-14} {1,-22} {2}{3} {4}" -f $c.Nome, $c.EA, $c.Simbolo, $Suffisso, $c.Periodo) -ForegroundColor DarkGray
}

# --- 2. terminale e cartella dati (stessa meccanica degli altri driver) ---
if(-not $Terminal){
  $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $c){ $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if($c){ $Terminal = $c.FullName; $MetaEditor = Join-Path $c.DirectoryName "metaeditor64.exe" }
}
if(-not $Terminal){ Muori "terminale MT5 non trovato." }
if($Terminal -and -not $DataFolder){
  $instDir = Split-Path -Parent $Terminal
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){
    $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue |
      Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } |
      Select-Object -First 1 -ExpandProperty FullName
  }
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){ Muori "cartella dati non trovata." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$Results    = Join-Path $Work "risultati_regime"
$IniDir     = Join-Path $Work "ini_regime"
New-Item -ItemType Directory -Force -Path $Results,$IniDir,$MqlExperts | Out-Null

Write-Host ""
Write-Host ("    terminale:  {0}" -f $Terminal) -ForegroundColor DarkGray
Write-Host ("    dati:       {0}" -f $DataFolder) -ForegroundColor DarkGray
Write-Host ("    risultati:  {0}" -f $Results) -ForegroundColor DarkGray

if($SoloControllo){
  Write-Host ""
  Write-Host "SoloControllo: non lancio niente. Se i simboli _EXT non esistono ancora," -ForegroundColor Yellow
  Write-Host "prima gira importa_storico_esterno.ps1." -ForegroundColor Yellow
  exit 0
}
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Muori "chiudi MetaTrader prima di lanciare (altrimenti zero CSV)."
}

# --- 3. compila gli EA che servono (una volta per EA) ---
$EAfatti = @{}
foreach($c in $Lista){
  if($EAfatti.ContainsKey($c.EA)){ continue }
  $src = Join-Path $MqlExperts ("{0}.mq5" -f $c.EA)
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($c.EA).mq5" -OutFile $src -UseBasicParsing }
  catch{ Muori "non riesco a scaricare l'EA $($c.EA)" }
  & $MetaEditor "/compile:$src" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts ("{0}.ex5" -f $c.EA)))){ Muori "compilazione fallita: $($c.EA)" }
  Write-Host ("    compilato {0}" -f $c.EA) -ForegroundColor Green
  $EAfatti[$c.EA] = $true
}

# --- 4. i lanci: cella x finestra ---
#     magic in SWEEP GEMELLO (due valori): serve al tester per produrre il
#     CSV di ottimizzazione, ed e' il controllo di igiene (le due righe
#     devono uscire identiche al centesimo).
$magic = 772601
$fatti = 0; $saltati = 0
foreach($c in $Lista){
  foreach($f in $Finestre){
    $sym = "{0}{1}" -f $c.Simbolo, $Suffisso
    $tag = "{0}_{1}_{2}" -f $c.Nome, $f.nome, $Etichetta
    $done = Join-Path $Results "$tag.csv"
    if(Test-Path $done){ Write-Host ("    {0}: gia' fatto, salto" -f $tag) -ForegroundColor DarkGray; $saltati++; continue }

    # input della cella: ogni parametro FISSO (nessuno sweep, sono celle congelate)
    $blocco = ""
    foreach($kv in ($c.Input -split ";")){
      $kv = $kv.Trim(); if($kv -eq ""){ continue }
      $nome = ($kv -split "=")[0].Trim(); $val = ($kv -split "=",2)[1].Trim()
      $blocco += "$nome=$val||$val||0||$val||N`r`n"
    }
    $m2 = $magic + 1
    $blocco += "InpMagic=$magic||$magic||1||$m2||Y`r`n"

    $ini = Join-Path $IniDir "$tag.ini"
    @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($c.EA).ex5
Symbol=$sym
Period=$($c.Periodo)
Model=$Modello
Optimization=2
OptimizationCriterion=6
FromDate=$($f.da)
ToDate=$($f.a)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag

[TesterInputs]
$blocco
"@ | Set-Content -Path $ini -Encoding ASCII

    $csv = Join-Path $MqlFiles ("OptResults_{0}_{1}.csv" -f $c.EA, $sym)
    if(Test-Path $csv){ Remove-Item $csv -Force }

    Write-Host ""
    Write-Host ("--- {0}  ({1} -> {2})  su {3} {4} ---" -f $tag, $f.da, $f.a, $sym, $c.Periodo) -ForegroundColor Cyan
    Start-Process -FilePath $Terminal -ArgumentList "/config:$ini" -Wait

    if(Test-Path $csv){
      Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
      $n = @(Get-Content $done).Count - 1
      if($n -le 0){ Write-Host ("    ATTENZIONE: {0}.csv senza passate (simbolo {1} inesistente? periodo senza dati?)" -f $tag,$sym) -ForegroundColor Red }
      else        { Write-Host ("    OK -> {0}.csv  ({1} righe)" -f $tag,$n) -ForegroundColor Green }
      $fatti++
    } else {
      Write-Host ("    NESSUN CSV per {0}: il simbolo {1} esiste? lo storico copre {2}-{3}?" -f $tag,$sym,$f.da,$f.a) -ForegroundColor Yellow
    }
    $magic += 2
  }
}

# --- 5. raccolta (regola delle righe di lancio) ---
$Dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "regime_$Etichetta"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item (Join-Path $Results "*$Etichetta.csv") $Dest -Force -ErrorAction SilentlyContinue
$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "regime_$Etichetta.zip"
Compress-Archive -Path (Join-Path $Dest "*") -DestinationPath $zip -Force -ErrorAction SilentlyContinue
$n = (Get-ChildItem $Dest -File -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host ""
Write-Host "=== FINITO ===" -ForegroundColor Cyan
Write-Host ("    lanci eseguiti: {0}   saltati (gia' fatti): {1}" -f $fatti, $saltati) -ForegroundColor Gray
Write-Host ("    ATTESI {0} CSV -> raccolti {1} in {2}" -f ($Lista.Count*$Finestre.Count), $n, $Dest) -ForegroundColor White
Write-Host ("    zip pronto: {0}" -f $zip) -ForegroundColor Green
Write-Host ""
Write-Host "    Il verdetto si scrive coi criteri di PROVA_REGIME_CRITERI.md," -ForegroundColor Yellow
Write-Host "    citando il criterio (A sopravvivenza, B tenuta, C rango, D due banchi)." -ForegroundColor Yellow
