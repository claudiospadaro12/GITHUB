# =====================================================================
#  deploy_vivaio_bb.ps1 -- VIVAIO BREAKING BAND (13/08): sedie 13-14-15
#  GBPUSD combinato / EURUSD solo CONT / AUDUSD solo INV (referto R34).
#  Si lancia SUL VPS. MT5 puo' restare aperto.
#  1) scarica ABTG_BreakingBand.mq5 (pinnato al commit v1.02) e lo
#     COMPILA sul VPS (prima volta di questo EA sul conto piccolo);
#  2) scrive i 3 preset VIVAIO_BB_*.set nella Presets del vecchio MT5.
#  DOPO lo script, sul vecchio MT5 (50503392), PER OGNUNO dei 3:
#   grafico H1 -> trascina ABTG_BreakingBand -> Carica preset ->
#   SCREENSHOT PRIMA DI OK -> verifica di Claude -> OK.
#  Alla fine: File -> Profili -> Salva Profilo (ORO) -> stringa verifica.
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EASHA = "24f4b7ac2d93d9f7a8b243152e055eaf4c8d78b9"   # commit della v1.02

# --- vecchio MT5: cartella dati + metaeditor ---
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
$src = Join-Path $Experts "ABTG_BreakingBand.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/ABTG_BreakingBand.mq5" -OutFile $src
& $meta "/compile:$src" "/log" | Out-Null
$ex5 = Join-Path $Experts "ABTG_BreakingBand.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "COMPILAZIONE FALLITA: apri MetaEditor sul VPS e guarda gli errori. NON procedere." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_BreakingBand compilato sul VPS ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- 2) i 3 preset (taratura CAL1 pinnata, gestione Leonardo) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16385","InpTPMode=0","InpRiskPercent=1.0",
            "InpBulgeWidthMult=1.35","InpBulgeNetMoveATR=1.0")
(@("InpPatternMode=2") + $comune + @("InpMagic=772161","InpComment=BB GBPUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_BB_GBPUSD.set") -Encoding ASCII
(@("InpPatternMode=0") + $comune + @("InpMagic=772162","InpComment=BB EURUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_BB_EURUSD.set") -Encoding ASCII
(@("InpPatternMode=1") + $comune + @("InpMagic=772163","InpComment=BB AUDUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_BB_AUDUSD.set") -Encoding ASCII
Write-Host "OK: scritti VIVAIO_BB_GBPUSD / _EURUSD / _AUDUSD .set" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 3 GRAFICI DA APRIRE (vecchio MT5, 50503392): ===" -ForegroundColor White
Write-Host "  1. GBPUSD H1 -> ABTG_BreakingBand -> Carica VIVAIO_BB_GBPUSD.set (magic 772161, pattern ENTRAMBI=2)"
Write-Host "  2. EURUSD H1 -> ABTG_BreakingBand -> Carica VIVAIO_BB_EURUSD.set (magic 772162, pattern CONT=0)"
Write-Host "  3. AUDUSD H1 -> ABTG_BreakingBand -> Carica VIVAIO_BB_AUDUSD.set (magic 772163, pattern INV=1)"
Write-Host ""
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica." -ForegroundColor Yellow
