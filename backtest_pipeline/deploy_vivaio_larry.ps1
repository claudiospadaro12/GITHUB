# =====================================================================
#  deploy_vivaio_larry.ps1 -- VIVAIO PUNTE DI LARRY (13/08): sedie 21-26
#  Sei grafici dal referto R39 (miglior ingresso della storia: 18->24
#  serie, +26% e DD storico 8,74->5,95). Si lancia SUL VPS.
#  1) scarica ABTG_PunteLarry.mq5 (pinnato al commit v1.00) e COMPILA;
#  2) scrive i 6 preset VIVAIO_LARRY_*.set nel vecchio MT5 (50503392).
#  DOPO lo script, PER OGNUNO dei 6: grafico H1 NUOVO -> trascina
#  ABTG_PunteLarry -> Carica preset -> SCREENSHOT PRIMA DI OK ->
#  verifica di Claude -> OK. Poi File -> Profili -> Salva Profilo (ORO)
#  -> stringa verifica (attesa: TUTTO OK 20/20).
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EASHA = "cb7dc20ab738d4d6791c74ff051ae8130b538fbd"   # commit della v1.00

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
$src = Join-Path $Experts "ABTG_PunteLarry.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/ABTG_PunteLarry.mq5" -OutFile $src
& $meta "/compile:$src" "/log" | Out-Null
$ex5 = Join-Path $Experts "ABTG_PunteLarry.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "COMPILAZIONE FALLITA: apri MetaEditor e guarda gli errori. NON procedere." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_PunteLarry compilato sul VPS ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- 2) i 6 preset (celle promosse in R38/R39) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16385","InpTP_R=1.5","InpSLMode=0","InpSLBufferATR=0.1",
            "InpAtrSlMult=1.5","InpAtrPeriodD1=14","InpSizeMinATR=0.0","InpSizeMaxATR=0.0",
            "InpMaxDaysHold=5","InpMaxSpreadPts=300","InpEntryWindowBars=3","InpRiskPercent=1.0")
function Scrivi($nome,$pat,$ex,$al,$ash,$magic,$comm){
  (@("InpPatternMode=$pat","InpExitMode=$ex","InpAllowLong=$al","InpAllowShort=$ash") + $script:comune +
   @("InpMagic=$magic","InpComment=$comm")) -join "`r`n" |
    Set-Content -Path (Join-Path $script:Presets "$nome.set") -Encoding ASCII
}
Scrivi "VIVAIO_LARRY_DOW"    1 1 1 1 772341 "LARRY DOW"
Scrivi "VIVAIO_LARRY_EURAUD" 1 1 1 1 772342 "LARRY EURAUD"
Scrivi "VIVAIO_LARRY_ORO"    0 1 1 0 772343 "LARRY ORO"
Scrivi "VIVAIO_LARRY_GBPJPY" 1 1 1 0 772344 "LARRY GBPJPY"
Scrivi "VIVAIO_LARRY_GBPUSD" 0 0 0 1 772345 "LARRY GBPUSD"
Scrivi "VIVAIO_LARRY_EURCAD" 1 0 1 0 772346 "LARRY EURCAD"
Write-Host "OK: scritti 6 preset VIVAIO_LARRY_*" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 6 GRAFICI DA APRIRE (vecchio MT5, 50503392), tutti H1 NUOVI: ===" -ForegroundColor White
Write-Host "  1. U30USD H1 -> VIVAIO_LARRY_DOW    (magic 772341, pattern PUNTA, exit R, L+S)"
Write-Host "  2. EURAUD H1 -> VIVAIO_LARRY_EURAUD (magic 772342, pattern PUNTA, exit R, L+S)"
Write-Host "  3. XAUUSD H1 -> VIVAIO_LARRY_ORO    (magic 772343, pattern LIBRO, exit R, SOLO LONG)"
Write-Host "  4. GBPJPY H1 -> VIVAIO_LARRY_GBPJPY (magic 772344, pattern PUNTA, exit R, SOLO LONG)"
Write-Host "  5. GBPUSD H1 -> VIVAIO_LARRY_GBPUSD (magic 772345, pattern LIBRO, exit FPO, SOLO SHORT)"
Write-Host "  6. EURCAD H1 -> VIVAIO_LARRY_EURCAD (magic 772346, pattern PUNTA, exit FPO, SOLO LONG)"
Write-Host ""
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK (anche a gruppi)." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica (attesa 20/20)." -ForegroundColor Yellow
