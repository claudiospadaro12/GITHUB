# =====================================================================
#  deploy_vivaio_gap2.ps1 -- VIVAIO GAP indici (13/08): sedie 19-20
#  U30USD fill 100 / 225JPY fill 75 -- STATO: OSSERVAZIONE.
#  Promossi in R36, ESCLUSI dal portafoglio in R37 (cumulo del lunedi':
#  bocciati anche a mezzo peso, +1.600 di profitto per +1,2 punti di
#  DD). Il vivaio serve a raccogliere il forward degli spread/fill
#  della riapertura INDICI: la porta del 100k resta chiusa finche' la
#  prova di portafoglio non cambia verdetto.
#  Si lancia SUL VPS. MT5 puo' restare aperto. L'EA e' gia' stato
#  compilato dal deploy del trio forex: qui si verifica e basta.
#  DOPO lo script, sul vecchio MT5 (50503392), PER OGNUNO dei 2:
#   grafico H1 NUOVO -> trascina ABTG_GapFill -> Carica preset ->
#   SCREENSHOT PRIMA DI OK -> verifica di Claude -> OK.
#  Alla fine: File -> Profili -> Salva Profilo (ORO) -> stringa verifica.
# =====================================================================
$ErrorActionPreference = "Stop"

# --- vecchio MT5 ---
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

# --- l'EA deve gia' esserci (compilato dal deploy del trio forex) ---
$ex5 = Join-Path $old.FullName "MQL5\Experts\ABTG_GapFill.ex5"
if (-not (Test-Path $ex5)) {
  Write-Host "ABTG_GapFill.ex5 NON trovato: lancia prima deploy_vivaio_gap.ps1." -ForegroundColor Red
  exit 1
}
Write-Host ("OK: ABTG_GapFill.ex5 presente ({0} byte)" -f (Get-Item $ex5).Length) -ForegroundColor Green

# --- i 2 preset (fill promossi in R36: Dow 100, Nikkei 75) ---
$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null
$comune = @("InpTF=16385","InpRiskPercent=1.0","InpGapMinATR=0.3","InpGapMaxATR=2.0",
            "InpSLMode=0","InpSLGapMult=1.0","InpMaxHours=48",
            "InpMaxSpreadPts=300","InpEntryWindowBars=3")
(@("InpFillPct=100") + $comune + @("InpMagic=772234","InpComment=GAP DOW")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_GAP_DOW.set") -Encoding ASCII
(@("InpFillPct=75")  + $comune + @("InpMagic=772235","InpComment=GAP NIKKEI")) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_GAP_NIKKEI.set") -Encoding ASCII
Write-Host "OK: scritti VIVAIO_GAP_DOW / _NIKKEI .set" -ForegroundColor Green
Write-Host ""
Write-Host "=== I 2 GRAFICI DA APRIRE (vecchio MT5, 50503392): ===" -ForegroundColor White
Write-Host "  1. U30USD H1 (nuovo) -> ABTG_GapFill -> Carica VIVAIO_GAP_DOW.set (magic 772234, fill 100)"
Write-Host "  2. 225JPY H1 (nuovo) -> ABTG_GapFill -> Carica VIVAIO_GAP_NIKKEI.set (magic 772235, fill 75!)"
Write-Host ""
Write-Host "NB: il Nikkei vuole il fill 75, NON 100 (col 100 in OOS faceva -74)." -ForegroundColor Yellow
Write-Host "SCREENSHOT di OGNI finestra input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "Poi File -> Profili -> Salva Profilo (ORO) e lancia la verifica." -ForegroundColor Yellow
