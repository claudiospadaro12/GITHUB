# =====================================================================
#  deploy_vivaio_ez.ps1 -- EASY TREND in OSSERVAZIONE (14/08): sedie 30-32
#  Tre grafici H1 dal referto R48 (walk-forward: 3 promossi su 4).
#  ATTENZIONE, e' un ingresso in OSSERVAZIONE, non in vivaio pieno:
#  R49 ha BOCCIATO la famiglia per il portafoglio (alza tutte le code,
#  p99 12,47 -> 14,63) -> **porta del 100k CHIUSA**, come i gap Dow e
#  Nikkei (sedie 19-20). Qui si raccoglie solo forward vero.
#  Si lancia SUL VPS.
#  1) scarica ABTG_EasyTrend.mq5 (pinnato al commit v1.00) e COMPILA;
#  2) scrive i 3 preset VIVAIO_EZ_*.set nel vecchio MT5 (50503392).
#  DOPO: per ognuno grafico H1 NUOVO -> trascina ABTG_EasyTrend ->
#  Carica preset -> SCREENSHOT PRIMA DI OK -> verifica di Claude -> OK.
#  Poi File -> Profili -> Salva Profilo (ORO) -> verifica (attesa 26/26).
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EASHA = "95bc4ec82a95ea58b664364c87d742c3ffef1275"   # commit della v1.00

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
$src = Join-Path $Experts "ABTG_EasyTrend.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/ABTG_EasyTrend.mq5" -OutFile $src
& $meta "/compile:$src" "/log" | Out-Null
$ex5 = Join-Path $Experts "ABTG_EasyTrend.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "COMPILAZIONE FALLITA: apri MetaEditor e guarda gli errori. NON procedere." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_EasyTrend compilato sul VPS ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- 2) i 3 preset (celle promosse in R48, tutte L+S, H1) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16385","InpPivotSource=0","InpPivotR=3","InpPivotL=5",
            "InpLinRegLen=11","InpPlotMode=0","InpPlotLen=11","InpCciPeriod=20",
            "InpMaxPivotDist=60","InpDivMaxBars=0","InpDivDieOnFail=0",
            "InpHourStart=8","InpHourEnd=18","InpPrevBars=3",
            "InpEntryWindowBars=3","InpMarketIfTooClose=1","InpSLBufferPts=30",
            "InpWarmupBars=500","InpMaxSpreadPts=30","InpRiskPercent=1.0",
            "InpAllowLong=1","InpAllowShort=1")
(@("InpTP_R=1.5") + $comune + @("InpMagic=772421","InpComment=EZ CHFJPY")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_EZ_CHFJPY.set") -Encoding ASCII
(@("InpTP_R=1.5") + $comune + @("InpMagic=772422","InpComment=EZ GBPUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_EZ_GBPUSD.set") -Encoding ASCII
(@("InpTP_R=1.0") + $comune + @("InpMagic=772423","InpComment=EZ AUDJPY")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_EZ_AUDJPY.set") -Encoding ASCII
Write-Host "OK: scritti VIVAIO_EZ_CHFJPY / _GBPUSD / _AUDJPY .set" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 3 GRAFICI DA APRIRE (vecchio MT5, 50503392), tutti H1 NUOVI: ===" -ForegroundColor White
Write-Host "  1. CHFJPY H1 -> VIVAIO_EZ_CHFJPY (magic 772421, TP 1.5, L+S)"
Write-Host "  2. GBPUSD H1 -> VIVAIO_EZ_GBPUSD (magic 772422, TP 1.5, L+S)"
Write-Host "  3. AUDJPY H1 -> VIVAIO_EZ_AUDJPY (magic 772423, TP 1.0, L+S)"
Write-Host ""
Write-Host "IN OSSERVAZIONE: porta del 100k CHIUSA (R49: alza le code del portafoglio)." -ForegroundColor Yellow
Write-Host "ATTENZIONE al filtro spread 30 pt (3 pip): se il funnel [EZ-FUNNEL] mostra" -ForegroundColor Yellow
Write-Host "molti blocchi per spread, si rivedra': ma NON si tocca senza misura." -ForegroundColor Yellow
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica (attesa 26/26)." -ForegroundColor Yellow
