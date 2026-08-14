# =====================================================================
#  misura_v21.ps1 -- misura AUTOMATICA del NasdaqOpeningBreakout v21
#  dell'amico sul PC DI BACKTEST: 2 lanci singoli (IS/OOS) a tick reali
#  con la SUA config (orario tradotto a BCM 14:25), report HTML del
#  tester raccolti sul Desktop e zippati.
#  Niente griglia: si misura LA SUA config, non si ottimizza.
#  Date = quelle del driver walk-forward (40/60, Fino 2026.06.30).
#  PRIMA: chiudi MetaTrader sul PC di backtest.
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Write-Host "!!! MetaTrader e' aperto: chiudilo e rilancia (il tester non parte con MT5 su)." -ForegroundColor Red
  exit 1
}

# --- terminal + cartella dati (stessa logica del driver) ---
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $c) { $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $c) { Write-Host "terminal64.exe non trovato." -ForegroundColor Red; exit 1 }
$Terminal = $c.FullName; $instDir = $c.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("PC: {0} | dati: {1}" -f $env:COMPUTERNAME, (Split-Path $DataFolder -Leaf)) -ForegroundColor Gray

# --- ex5 (riscarica sempre: regola delle righe di lancio) ---
$destDir = Join-Path $DataFolder "MQL5\Experts\esterni"
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
$exUrl = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/esterni/NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5"
$exPath = Join-Path $destDir "NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5"
Invoke-WebRequest -Uri $exUrl -OutFile $exPath -UseBasicParsing
Write-Host ("ex5: {0} byte (attesi 63340)" -f (Get-Item $exPath).Length) -ForegroundColor Gray

# --- config dell'amico, orario BCM (unica traduzione dichiarata) ---
$Inputs = @"
TradeStartTime=14:25
BaseEntryOffset=7.0
PendingOrderLifetimeMin=7
BaseLotSize=0.1
UseRiskPercent=false
RiskPercent=1.0
BaseStopLoss=50.0
BaseTakeProfit=100.0
UsePartialClose=true
PartialClosePercent=50.0
PartialCloseTarget=30.0
UseBreakEven=true
BreakEvenActivation=20.0
BreakEvenOffset=5.0
UseTrailingStop=true
TrailingStart=30.0
TrailingStep=10.0
EnableSR_Detection=true
EnableSR_Filter=true
SR_ProximityPoints=15.0
SwingStrength=5
UsePreviousDayLevels=true
UseRoundNumbers=true
RoundNumberInterval=100.0
SR_MergeDistance=10.0
UseVolatilityRegime=true
ATR_Period=14
ATR_LookbackBars=100
LowVolPercentile=20.0
HighVolPercentile=80.0
LowVol_OffsetMult=0.7
HighVol_OffsetMult=1.5
LowVol_SL_Mult=0.75
HighVol_SL_Mult=1.5
HighVol_SizeReduction=0.5
UseCorrelationFilter=false
CorrelationSymbol=US500
CorrelationPeriod=50
MinCorrelation=0.7
UseMTF_Filter=false
MTF_Timeframe=16385
MTF_EMA_Period=50
BlockCounterTrend=false
TrendBias_SizeMult=2.0
MaxTradesPerDay=2
MaxDailyLossPercent=2.0
AvoidMonday=false
AvoidFriday=false
UpdateIntervalSec=60
MinimalLogs=true
DisableDashboard=true
MagicNumber=123456
EnableDebugLogs=false
"@

# --- 2 finestre, stesse date del driver (40/60, Fino 2026.06.30) ---
$WF = @(
  @{ Tag="IS";  Da="2024.09.26"; A="2025.06.09" },
  @{ Tag="OOS"; Da="2025.06.10"; A="2026.06.30" }
)

$prima = Get-Date
foreach ($w in $WF) {
  $rep = "V21_" + $w.Tag
  $ini = Join-Path $env:TEMP ("gen_v21_" + $w.Tag + ".ini")
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=esterni\NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5
Symbol=NASUSD
Period=M20
Model=4
Optimization=0
FromDate=$($w.Da)
ToDate=$($w.A)
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
Visual=0
ReplaceReport=1
ShutdownTerminal=1
Report=$rep

[TesterInputs]
$Inputs
"@ | Set-Content -Path $ini -Encoding ASCII
  Write-Host ""
  Write-Host ("--- {0}: {1} -> {2} (tick reali, config amico) ---" -f $w.Tag, $w.Da, $w.A) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()
  Write-Host ("    lancio {0} finito." -f $w.Tag) -ForegroundColor Green
}

# --- raccolta report (possono stare nella cartella dati o in quella d'installazione) ---
$dest = Join-Path $env:USERPROFILE "Desktop\misura_v21"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$trovati = @()
foreach ($dir in @($DataFolder, $instDir)) {
  $trovati += Get-ChildItem $dir -Filter "V21_*.htm*" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $prima }
  $trovati += Get-ChildItem $dir -Filter "V21_*.png" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $prima }
}
if ($trovati.Count -eq 0) {
  Write-Host "NESSUN report V21_* trovato: manda screenshot della scheda Backtest del tester." -ForegroundColor Red
} else {
  $trovati | ForEach-Object { Copy-Item $_.FullName $dest -Force; Write-Host ("  raccolto: " + $_.Name) -ForegroundColor Green }
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath (Join-Path $env:USERPROFILE "Desktop\v21_report.zip") -Force
  Write-Host ""
  Write-Host "=== FATTO: Desktop\v21_report.zip (attesi: V21_IS.htm e V21_OOS.htm, piu' eventuali .png) ===" -ForegroundColor Green
}
