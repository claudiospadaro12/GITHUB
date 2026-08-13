# =====================================================================
#  deploy_vivaio_cost.ps1 -- VIVAIO COST-TO-COST (13/08): sedie 27-29
#  Tre grafici H4 dal referto R41 (quarto "aggiunge e abbassa": 24->27
#  serie, +23% e DD 5,95->5,50). ATTENZIONE: famiglia con avvertenza
#  (campo scan rosso 28/48): il forward qui pesa piu' che altrove.
#  Si lancia SUL VPS.
#  1) scarica ABTG_CostToCost.mq5 (pinnato al commit v1.00) e COMPILA;
#  2) scrive i 3 preset VIVAIO_COST_*.set nel vecchio MT5 (50503392).
#  DOPO: per ognuno grafico **H4** NUOVO -> trascina ABTG_CostToCost ->
#  Carica preset -> SCREENSHOT PRIMA DI OK -> verifica di Claude -> OK.
#  Poi File -> Profili -> Salva Profilo (ORO) -> verifica (attesa 23/23).
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EASHA = "9b1c61191c7516bd2a61ccf50cbb37e16b170759"   # commit della v1.00

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }
$instDir = (Get-Content (Join-Path $old.FullName "origin.txt") -Raw).Trim()
$meta = Join-Path $instDir "metaeditor64.exe"
if (-not (Test-Path $meta)) { Write-Host "metaeditor64.exe non trovato in $instDir" -ForegroundColor Red; exit 1 }

# --- 1) sorgente + compilazione ---
$Experts = Join-Path $old.FullName "MQL5\Experts"
$src = Join-Path $Experts "ABTG_CostToCost.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/ABTG_CostToCost.mq5" -OutFile $src
& $meta "/compile:$src" "/log" | Out-Null
$ex5 = Join-Path $Experts "ABTG_CostToCost.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "COMPILAZIONE FALLITA: apri MetaEditor e guarda gli errori. NON procedere." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_CostToCost compilato sul VPS ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- 2) i 3 preset (celle promosse in R40/R41, tutti SOLO LONG, H4) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16388","InpTP_R=1.5","InpSLBufferATR=0.2","InpAtrPeriod=14",
            "InpMinRangeATR=0.0","InpMaxBarsHold=100","InpMaxSpreadPts=300",
            "InpEntryWindowBars=3","InpWarmupBars=500","InpRiskPercent=1.0",
            "InpAllowLong=1","InpAllowShort=0")
(@("InpExitMode=2") + $comune + @("InpMagic=772361","InpComment=COST EURJPY")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_COST_EURJPY.set") -Encoding ASCII
(@("InpExitMode=1") + $comune + @("InpMagic=772362","InpComment=COST GBPCAD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_COST_GBPCAD.set") -Encoding ASCII
(@("InpExitMode=0") + $comune + @("InpMagic=772363","InpComment=COST XAGUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_COST_XAGUSD.set") -Encoding ASCII
Write-Host "OK: scritti VIVAIO_COST_EURJPY / _GBPCAD / _XAGUSD .set" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 3 GRAFICI DA APRIRE (vecchio MT5, 50503392), tutti *** H4 *** NUOVI: ===" -ForegroundColor White
Write-Host "  1. EURJPY H4 -> VIVAIO_COST_EURJPY (magic 772361, exit FLIP=2, SOLO LONG)"
Write-Host "  2. GBPCAD H4 -> VIVAIO_COST_GBPCAD (magic 772362, exit R=1, SOLO LONG)"
Write-Host "  3. XAGUSD H4 -> VIVAIO_COST_XAGUSD (magic 772363, exit COST=0, SOLO LONG)"
Write-Host ""
Write-Host "ATTENZIONE: TIMEFRAME H4, non H1 (primi H4 del vivaio dai tempi di SW H2)!" -ForegroundColor Yellow
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica (attesa 23/23)." -ForegroundColor Yellow
