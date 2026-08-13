# =====================================================================
#  deploy_vivaio_gap.ps1 -- VIVAIO GAP-FILL (13/08): sedie 16-17-18
#  GBPUSD fill 100 / EURUSD fill 50 / AUDUSD fill 100 (referto R37:
#  trio forex promosso; Dow e Nikkei in panchina di portafoglio).
#  Si lancia SUL VPS. MT5 puo' restare aperto.
#  1) scarica ABTG_GapFill.mq5 (pinnato al commit v1.00) e lo COMPILA
#     sul VPS (prima volta di questo EA sul conto piccolo);
#  2) scrive i 3 preset VIVAIO_GAP_*.set nella Presets del vecchio MT5.
#  DOPO lo script, sul vecchio MT5 (50503392), PER OGNUNO dei 3:
#   grafico H1 NUOVO (i 3 cambi hanno GIA' il grafico BB: aprirne un
#   ALTRO sullo stesso simbolo) -> trascina ABTG_GapFill -> Carica
#   preset -> SCREENSHOT PRIMA DI OK -> verifica di Claude -> OK.
#  Alla fine: File -> Profili -> Salva Profilo (ORO) -> stringa verifica.
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EASHA = "a7666599b4092351a61f6ea76e2ea6aaa6e1679e"   # commit della v1.00

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
$src = Join-Path $Experts "ABTG_GapFill.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/ABTG_GapFill.mq5" -OutFile $src
& $meta "/compile:$src" "/log" | Out-Null
$ex5 = Join-Path $Experts "ABTG_GapFill.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "COMPILAZIONE FALLITA: apri MetaEditor sul VPS e guarda gli errori. NON procedere." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_GapFill compilato sul VPS ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- 2) i 3 preset (taratura di tesi, fill promossi in R36/R37) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16385","InpRiskPercent=1.0","InpGapMinATR=0.3","InpGapMaxATR=2.0",
            "InpSLMode=0","InpSLGapMult=1.0","InpMaxHours=48",
            "InpMaxSpreadPts=300","InpEntryWindowBars=3")
(@("InpFillPct=100") + $comune + @("InpMagic=772231","InpComment=GAP GBPUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_GAP_GBPUSD.set") -Encoding ASCII
(@("InpFillPct=50")  + $comune + @("InpMagic=772232","InpComment=GAP EURUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_GAP_EURUSD.set") -Encoding ASCII
(@("InpFillPct=100") + $comune + @("InpMagic=772233","InpComment=GAP AUDUSD")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_GAP_AUDUSD.set") -Encoding ASCII
Write-Host "OK: scritti VIVAIO_GAP_GBPUSD / _EURUSD / _AUDUSD .set" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 3 GRAFICI DA APRIRE (vecchio MT5, 50503392): ===" -ForegroundColor White
Write-Host "  NB: sono grafici NUOVI, IN AGGIUNTA a quelli BB sugli stessi cambi!" -ForegroundColor Yellow
Write-Host "  1. GBPUSD H1 (nuovo) -> ABTG_GapFill -> Carica VIVAIO_GAP_GBPUSD.set (magic 772231, fill 100)"
Write-Host "  2. EURUSD H1 (nuovo) -> ABTG_GapFill -> Carica VIVAIO_GAP_EURUSD.set (magic 772232, fill 50)"
Write-Host "  3. AUDUSD H1 (nuovo) -> ABTG_GapFill -> Carica VIVAIO_GAP_AUDUSD.set (magic 772233, fill 100)"
Write-Host ""
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica." -ForegroundColor Yellow
