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
  # --- 14/08, per il collaudo a due tempi (bisezione) ---
  #  Il blocco [Experts] l'ho aggiunto io stamattina agli ini di TUTTI i
  #  driver. Da allora l'unica cosa che ha girato e' R50, che non ha mai
  #  funzionato: quindi non ho nessun caso "con il blocco e funzionante".
  #  Avevo scritto che era innocente perche' l'ini lo conteneva e
  #  l'ottimizzazione non partiva: e' un ragionamento circolare, non una
  #  prova. Con questi due interruttori si fa l'esperimento vero, un
  #  lancio solo per volta.
  [switch]$SoloUno,             # esegue UN solo lancio e si ferma
  [switch]$SenzaBlindatura,     # NON scrive il blocco [Experts] nell'ini
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
  # 14/08: lo scaricamento falliva SEMPRE quando lo script veniva lanciato da
  # %TEMP% (cioe' con la riga irm), perche' la sottocartella prove\ non c'era e
  # Invoke-WebRequest non la crea. Il messaggio diceva "manca il file delle
  # celle" e faceva pensare a un file mancante sul repo: era una cartella.
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Celle) | Out-Null
  try{ Invoke-WebRequest -Uri "$RawBase/backtest_pipeline/prove/CELLE_REGIME.txt" -OutFile $Celle -UseBasicParsing }
  catch{ Muori ("non riesco a procurarmi il file delle celle: $Celle`n" +
                "    motivo: " + $_.Exception.Message) }
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
  Write-Host "    gli .ini nasceranno con [Experts] AllowLiveTrading=false:" -ForegroundColor Green
  Write-Host "    lanciare il tester AVVIA il terminale, che senza questa riga" -ForegroundColor Gray
  Write-Host "    riarmerebbe gli EA sui grafici del conto collegato (14/08/2026)." -ForegroundColor Gray
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
  # LA TRAPPOLA N.1, quella che walkforward_generico documenta in testa:
  # MT5 RICORDA per ogni EA i flag di ottimizzazione dell'ultima griglia,
  # e li tiene in MQL5\Profiles\Tester\<EA>.set. Passare in [TesterInputs]
  # solo ALCUNI parametri non spegne il flag sugli altri: se uno di quelli
  # rimasti ha uno sweep degenere (start uguale a stop, oppure passo zero)
  # il tester calcola ZERO combinazioni e non avvia niente - nessun agente,
  # nessun log, nessun CSV. Walkforward lo evita blindando TUTTI gli input;
  # qui si fa la cosa piu' diretta e senza rischio di sbagliare un default:
  # si butta via la memoria e MT5 riparte dai valori compilati.
  $ricordo = Join-Path $DataFolder ("MQL5\Profiles\Tester\{0}.set" -f $c.EA)
  if(Test-Path $ricordo){
    Remove-Item $ricordo -Force -ErrorAction SilentlyContinue
    Write-Host ("    buttata la memoria del tester per {0}" -f $c.EA) -ForegroundColor DarkYellow
  }
  Write-Host ("    compilato {0}" -f $c.EA) -ForegroundColor Green
  $EAfatti[$c.EA] = $true
}

# --- 4. i lanci: cella x finestra ---
#     magic in SWEEP GEMELLO (due valori): serve al tester per produrre il
#     CSV di ottimizzazione, ed e' il controllo di igiene (le due righe
#     devono uscire identiche al centesimo).
#
#     14/08: il primo giro ha prodotto ZERO CSV su 32 lanci. Causa:
#     l'ini diceva Optimization=2, cioe' l'algoritmo GENETICO, su uno
#     spazio di DUE sole combinazioni. Il genetico ha bisogno di una
#     popolazione: con due punti non ha niente da far evolvere e non
#     produce passate. scan_market.ps1 usa 2 e funziona, ma li' le
#     combinazioni sono centinaia; walkforward_generico.ps1, che gira da
#     mesi, usa 1. Qui la scelta giusta e' 1 (enumerazione completa):
#     con due combinazioni e' anche la piu' veloce.
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
    $blindatura = if($SenzaBlindatura){ "" } else { "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" }
    @"
$blindatura[Tester]
Expert=$($c.EA).ex5
Symbol=$sym
Period=$($c.Periodo)
Model=$Modello
Optimization=1
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
    $prima = Get-Date
    # percorso QUOTATO e attesa sul solo terminale, come nei due driver che
    # funzionano da mesi: prova_regime era l'unico script del repo a fare
    # diversamente, e non c'e' ragione di restare l'eccezione.
    (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

    # RIPIEGO (ce l'ha walkforward_generico, qui mancava): se l'EA compone il
    # nome in modo diverso da come lo prevedo, senza questo direi "NESSUN CSV"
    # anche a tester andato benissimo. Cerco qualunque OptResults_ scritto
    # DOPO l'avvio di questo lancio.
    if(-not (Test-Path $csv)){
      $alt = @(Get-ChildItem $MqlFiles -Filter "OptResults_*.csv" -EA SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $prima } |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1)
      if($alt.Count -gt 0){
        Write-Host ("    CSV trovato con un altro nome: {0}" -f $alt[0].Name) -ForegroundColor Yellow
        $csv = $alt[0].FullName
      }
    }
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
    if($SoloUno){
      Write-Host ""
      Write-Host "-SoloUno: mi fermo qui." -ForegroundColor Yellow
      Write-Host ("    blindatura [Experts] nell'ini: " + $(if($SenzaBlindatura){"NO"}else{"SI"})) -ForegroundColor Yellow
      Write-Host ("    CSV atteso: " + $done) -ForegroundColor Yellow
      Write-Host ("    ESITO: " + $(if(Test-Path $done){"CSV CREATO"}else{"NESSUN CSV"})) -ForegroundColor $(if(Test-Path $done){"Green"}else{"Red"})
      exit 0
    }
  }
}

# --- 5. raccolta (regola delle righe di lancio) ---
#  Il Desktop si cerca in tre modi e gli errori NON si ingoiano: dopo 32
#  lanci, uno zip che non nasce in silenzio e' il modo peggiore di finire.
function Trova-Desktop {
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path $p)){ return $p }
  }
  return $env:USERPROFILE
}
$desktop = Trova-Desktop
$Dest = Join-Path $desktop "regime_$Etichetta"
$zip  = Join-Path $desktop "regime_$Etichetta.zip"
$zipOk = $false
$motivoZip = ""
try{
  New-Item -ItemType Directory -Force -Path $Dest -ErrorAction Stop | Out-Null
  Copy-Item (Join-Path $Results "*$Etichetta.csv") $Dest -Force -ErrorAction SilentlyContinue
  if(Test-Path $zip){ Remove-Item $zip -Force -ErrorAction Stop }
  Compress-Archive -Path (Join-Path $Dest "*") -DestinationPath $zip -Force -ErrorAction Stop
  $zipOk = Test-Path $zip
}catch{
  $motivoZip = $_.Exception.Message
}
$n = (Get-ChildItem $Dest -File -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host ""
Write-Host "=== FINITO ===" -ForegroundColor Cyan
Write-Host ("    lanci eseguiti: {0}   saltati (gia' fatti): {1}" -f $fatti, $saltati) -ForegroundColor Gray
Write-Host ("    ATTESI {0} CSV -> raccolti {1} in {2}" -f ($Lista.Count*$Finestre.Count), $n, $Dest) -ForegroundColor White
if($zipOk){
  Write-Host ("    zip pronto: {0}" -f $zip) -ForegroundColor Green
}else{
  Write-Host "    ZIP NON CREATO" -ForegroundColor Yellow
  if($motivoZip){ Write-Host ("    motivo: " + $motivoZip) -ForegroundColor Red }
  Write-Host ("    I CSV stanno comunque qui, mandami questa cartella: {0}" -f $Results) -ForegroundColor Yellow
}
Write-Host ""
Write-Host "    Il verdetto si scrive coi criteri di PROVA_REGIME_CRITERI.md," -ForegroundColor Yellow
Write-Host "    citando il criterio (A sopravvivenza, B tenuta, C rango, D due banchi)." -ForegroundColor Yellow
