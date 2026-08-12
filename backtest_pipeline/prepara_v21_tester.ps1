# =====================================================================
#  prepara_v21_tester.ps1 -- prepara il PC DI BACKTEST per la misura
#  del NasdaqOpeningBreakout v21 dell'amico (12/08).
#  1) scarica l'ex5 dal repo in MQL5\Experts\esterni\ del tester;
#  2) scrive il preset V21_AMICO.set = la SUA config, con l'UNICA
#     traduzione dichiarata: TradeStartTime 16:25 -> 14:25 (fuso BCM:
#     5 minuti prima dell'apertura Nasdaq 14:30 server, come da tesi
#     dell'autore sul suo broker UTC+3);
#  3) stampa la checklist dei 2 lanci manuali nel tester grafico.
#  L'imbuto automatico non si applica (ex5 esterno senza il nostro
#  blocco OnTester): i risultati si leggono dal report del tester.
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- terminal del PC di backtest (stessa logica del driver walk-forward)
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $c) { $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $c) { Write-Host "terminal64.exe non trovato: sei sul PC di backtest?" -ForegroundColor Red; exit 1 }
$instDir = $c.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("PC: {0}  |  dati MT5: {1}" -f $env:COMPUTERNAME, (Split-Path $DataFolder -Leaf)) -ForegroundColor Gray

# --- 1) ex5 dal repo ---
$destDir = Join-Path $DataFolder "MQL5\Experts\esterni"
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
$url = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/esterni/NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5"
$dest = Join-Path $destDir "NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5"
Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
$len = (Get-Item $dest).Length
if ($len -lt 50000) { Write-Host ("ATTENZIONE: ex5 sospettosamente piccolo ({0} byte)" -f $len) -ForegroundColor Red }
Write-Host ("OK ex5 scaricato: {0} ({1} byte, attesi 63340)" -f $dest, $len) -ForegroundColor Green

# --- 2) preset con la config dell'amico (unica modifica: orario BCM) ---
$Presets = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
@("; V21_AMICO -- config originale dell'amico, orario tradotto a BCM (14:25)",
  "TradeStartTime=14:25",
  "BaseEntryOffset=7.0",
  "PendingOrderLifetimeMin=7",
  "BaseLotSize=0.1",
  "UseRiskPercent=false",
  "RiskPercent=1.0",
  "BaseStopLoss=50.0",
  "BaseTakeProfit=100.0",
  "UsePartialClose=true",
  "PartialClosePercent=50.0",
  "PartialCloseTarget=30.0",
  "UseBreakEven=true",
  "BreakEvenActivation=20.0",
  "BreakEvenOffset=5.0",
  "UseTrailingStop=true",
  "TrailingStart=30.0",
  "TrailingStep=10.0",
  "EnableSR_Detection=true",
  "EnableSR_Filter=true",
  "SR_ProximityPoints=15.0",
  "SwingStrength=5",
  "UsePreviousDayLevels=true",
  "UseRoundNumbers=true",
  "RoundNumberInterval=100.0",
  "SR_MergeDistance=10.0",
  "UseVolatilityRegime=true",
  "ATR_Period=14",
  "ATR_LookbackBars=100",
  "LowVolPercentile=20.0",
  "HighVolPercentile=80.0",
  "LowVol_OffsetMult=0.7",
  "HighVol_OffsetMult=1.5",
  "LowVol_SL_Mult=0.75",
  "HighVol_SL_Mult=1.5",
  "HighVol_SizeReduction=0.5",
  "UseCorrelationFilter=false",
  "CorrelationSymbol=US500",
  "CorrelationPeriod=50",
  "MinCorrelation=0.7",
  "UseMTF_Filter=false",
  "MTF_Timeframe=16385",
  "MTF_EMA_Period=50",
  "BlockCounterTrend=false",
  "TrendBias_SizeMult=2.0",
  "MaxTradesPerDay=2",
  "MaxDailyLossPercent=2.0",
  "AvoidMonday=false",
  "AvoidFriday=false",
  "UpdateIntervalSec=60",
  "MinimalLogs=true",
  "DisableDashboard=true",
  "MagicNumber=123456",
  "EnableDebugLogs=false") -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "V21_AMICO.set") -Encoding ASCII
Write-Host "OK preset scritto: V21_AMICO.set" -ForegroundColor Green

# --- 3) checklist dei 2 lanci ---
Write-Host ""
Write-Host "=== ADESSO NEL TESTER GRAFICO (MT5 del PC di backtest): ===" -ForegroundColor White
Write-Host "  Visualizza -> Tester di strategia (Ctrl+R), scheda Panoramica/Impostazioni:"
Write-Host "   - Expert:   esterni\NasdaqOpeningBreakout_EA_v21_OPTIMIZED"
Write-Host "   - Simbolo:  NASUSD    Periodo: M20 (come lo teneva l'amico)"
Write-Host "   - Modello:  'Ogni tick basato su tick reali'"
Write-Host "   - Deposito: 10000     Ottimizzazione: DISATTIVATA"
Write-Host "   - Parametri di input -> Carica -> V21_AMICO.set"
Write-Host "     (controlla: TradeStartTime=14:25, BaseLotSize=0.1)"
Write-Host ""
Write-Host "  LANCIO 1 (IS):  date personalizzate 2024.09.26 -> 2025.06.09" -ForegroundColor Yellow
Write-Host "  LANCIO 2 (OOS): date personalizzate 2025.06.10 -> 2026.06.30" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Dopo OGNI lancio: scheda 'Backtest' del tester -> SCREENSHOT" -ForegroundColor Cyan
Write-Host "  (servono: Profitto netto, Fattore di profitto, Drawdown, Trade totali)" -ForegroundColor Cyan
