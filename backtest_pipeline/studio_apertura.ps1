# =====================================================================
#  studio_apertura.ps1  --  STUDIO APERTURA (LONG vs SHORT) via PowerShell
# ---------------------------------------------------------------------
#  Fa girare l'EA di studio ABTG_Apertura_Study_EA nello Strategy Tester
#  (UN passaggio, NON ottimizzazione) su DAX (D30EUR) e Nasdaq (NASUSD),
#  pagando lo slippage realistico. A fine giro trovi i due CSV in
#  .\risultati_studio\ e il riepilogo (aspettativa in R per LONG/SHORT/
#  filtro H4) nel giornale del tester.
#
#  USO:  powershell -ExecutionPolicy Bypass -File studio_apertura.ps1
#
#  L'UNICA cosa da controllare: le ORE D'APERTURA sul TUO broker (server).
#  Se sul tuo grafico il DAX apre alle 10:00 e non alle 09:00, cambia
#  $DaxOpenHour qui sotto. Idem per il Nasdaq.
# =====================================================================
param(
    [int]$DaxOpenHour = 9,   [int]$DaxOpenMin = 0,
    [int]$NasOpenHour = 15,  [int]$NasOpenMin = 30,
    [double]$BufferPts = 200, [double]$SlippagePts = 100, [double]$TP_R = 2.0,
    [string]$FromDate = "2024.01.01", [string]$ToDate = "2026.07.01"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$EAName   = "ABTG_Apertura_Study_EA"

Write-Host "=== STUDIO APERTURA (LONG vs SHORT, con slippage) ===" -ForegroundColor Cyan

# --- rileva terminale BCM + cartella dati (come run_all) -------------
$Terminal=""; $MetaEditor=""; $DataFolder=""
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if ($cand) { $Terminal=$cand.FullName; $MetaEditor=Join-Path $cand.DirectoryName "metaeditor64.exe" }
if ($Terminal) {
    $instDir=Split-Path -Parent $Terminal
    $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
    if (Test-Path $termRoot) {
        $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
            $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
        } | Select-Object -First 1 -ExpandProperty FullName
    }
}
Write-Host ("Terminale : {0}" -f $Terminal)
Write-Host ("Cartella dati: {0}" -f $DataFolder)
if (-not $Terminal -or -not (Test-Path $Terminal)) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

$MqlExperts  = Join-Path $DataFolder "MQL5\Experts"
# Nel tester i file con FILE_COMMON finiscono qui (NON in MQL5\Files):
$CommonFiles = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Results     = Join-Path $RepoRoot "risultati_studio"
$IniDir     = Join-Path $RepoRoot "ini_studio"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,$IniDir | Out-Null

# --- trova (o scarica) l'EA di studio, poi compila -------------------
Write-Host "`n[1/3] Copio e compilo $EAName ..." -ForegroundColor Yellow
$eaCandidates = @(
    (Join-Path $RepoRoot "..\mql5\Experts\$EAName.mq5"),
    (Join-Path $RepoRoot "$EAName.mq5"),
    (Join-Path (Get-Location) "$EAName.mq5")
)
$eaSrc = $eaCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $eaSrc) {
    Write-Host "   EA non trovato in locale: lo scarico da GitHub..." -ForegroundColor Yellow
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $rawBase = "https://raw.githubusercontent.com/claudiospadaro12/github/claude/creating-agents-SgGpD"
        $eaSrc = Join-Path $env:TEMP "$EAName.mq5"
        Invoke-WebRequest "$rawBase/mql5/Experts/$EAName.mq5" -OutFile $eaSrc -UseBasicParsing
    } catch {
        Write-Host "   Download fallito: $($_.Exception.Message)" -ForegroundColor Red; exit 1
    }
}
Copy-Item $eaSrc -Destination $MqlExperts -Force
$src = Join-Path $MqlExperts "$EAName.mq5"
& $MetaEditor "/compile:$src" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($src, ".ex5")
if (-not (Test-Path $ex5)) { Write-Host "   ERRORE compilazione $EAName. Apri MetaEditor e premi F7 per vedere l'errore." -ForegroundColor Red; exit 1 }
Write-Host "   OK compilato." -ForegroundColor Green

# --- costruisce un .ini a passaggio singolo --------------------------
function New-StudyIni($sym,$oh,$om) {
@"
[Tester]
Expert=$EAName.ex5
Symbol=$sym
Period=M5
Model=1
Optimization=0
FromDate=$FromDate
ToDate=$ToDate
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=StudyReport_$sym

[TesterInputs]
InpSessionHour=$oh
InpSessionMin=$om
InpRangeMinutes=15
InpBufferPts=$BufferPts
InpSlippagePts=$SlippagePts
InpTP_R=$TP_R
InpH4EmaPeriod=50
"@
}

$jobs = @(
    @{ sym="D30EUR"; oh=$DaxOpenHour; om=$DaxOpenMin; label="DAX" },
    @{ sym="NASUSD"; oh=$NasOpenHour; om=$NasOpenMin; label="Nasdaq" }
)

Write-Host "`n[2/3] Eseguo lo studio (1 passaggio per simbolo)..." -ForegroundColor Yellow
foreach ($j in $jobs) {
    $iniPath = Join-Path $IniDir ("studio_" + $j.sym + ".ini")
    New-StudyIni $j.sym $j.oh $j.om | Set-Content -Path $iniPath -Encoding ASCII
    Write-Host ("   {0} ({1}) apertura {2:00}:{3:00} ..." -f $j.label,$j.sym,$j.oh,$j.om) -ForegroundColor Cyan
    $proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru
    $proc.WaitForExit()
    Write-Host "        fatto." -ForegroundColor Green
}

# --- raccogli i CSV --------------------------------------------------
Write-Host "`n[3/3] Raccolgo i CSV..." -ForegroundColor Yellow
$found = 0
foreach ($j in $jobs) {
    $csv = Join-Path $CommonFiles ("ABTG_Apertura_Study_" + $j.sym + ".csv")
    $sum = Join-Path $CommonFiles ("ABTG_Apertura_Study_" + $j.sym + "_RIEPILOGO.csv")
    if (Test-Path $csv) { Copy-Item $csv -Destination $Results -Force; $found++; Write-Host "   OK  $($j.sym)" -ForegroundColor Green }
    else { Write-Host "   MANCA il CSV per $($j.sym) (0 trade? ora d'apertura sbagliata?)" -ForegroundColor Red }
    if (Test-Path $sum) {
        Copy-Item $sum -Destination $Results -Force
        Write-Host "   --- RIEPILOGO $($j.sym) ---" -ForegroundColor Cyan
        Get-Content $sum | ForEach-Object { Write-Host "   $_" }
    }
}

Write-Host "`n=== FINITO ($found/2 CSV) ===" -ForegroundColor Cyan
Write-Host "CSV in: $Results" -ForegroundColor White
Write-Host "Il RIEPILOGO (LONG vs SHORT, filtro H4) e' nel giornale del tester:" -ForegroundColor White
Write-Host "  MT5 > scheda 'Strategy Tester' > 'Giornale', oppure $DataFolder\Tester\logs\" -ForegroundColor Gray
Write-Host "Mandami i 2 CSV (o le righe di riepilogo) e scegliamo i parametri dai dati." -ForegroundColor White
