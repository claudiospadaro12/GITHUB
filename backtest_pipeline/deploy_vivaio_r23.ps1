# =====================================================================
#  deploy_vivaio_r23.ps1 -- scrive i 5 preset del VIVAIO R23 nel
#  VECCHIO MT5 (demo piccolo 50503392). Scaletta: report/VIVAIO_R23_DEPLOY.md
#  Si lancia SUL VPS. MT5 puo' restare aperto (i preset si leggono
#  quando apri la finestra degli input).
#
#  DOPO lo script, per ognuno dei 5:
#   1. apri il grafico col SIMBOLO e TF della tabella;
#   2. trascina l'EA dal Navigatore sul grafico;
#   3. scheda "Parametri di input" -> Carica -> scegli il preset VIVAIO_*;
#   4. screenshot degli input PRIMA di dare OK -> verifica campo-per-campo.
# =====================================================================
$ErrorActionPreference = "Stop"

# --- cartella dati del VECCHIO MT5 (non -V3), via origin.txt ---------
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("Istanza: " + (Get-Content (Join-Path $old.FullName "origin.txt") -Raw).Trim()) -ForegroundColor Gray

$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null

# --- i 5 preset (solo gli input che CAMBIANO dai default) ------------
# NB: InpTF numerico: 16385 = H1, 16386 = H2 (enum MT5)
$Set = @{
  "VIVAIO_PTE_DOW.set"     = @("InpTF=16385","InpTP1_ATRmult=0.5","InpRiskPercent=1.0","InpMagic=771321","InpComment=PTE DOW")
  "VIVAIO_PTE_GBPUSD.set"  = @("InpTF=16385","InpTP1_ATRmult=0.5","InpRiskPercent=1.0","InpMagic=771322","InpComment=PTE GBPUSD")
  "VIVAIO_PTE_USDJPY.set"  = @("InpTF=16385","InpTP1_ATRmult=0.5","InpRiskPercent=1.0","InpMagic=771323","InpComment=PTE USDJPY")
  "VIVAIO_SW_DOW.set"      = @("InpTF=16386","InpRiskPercent=1.0","InpMagic=770531","InpComment=SW DOW H2")
  "VIVAIO_SW_GBPUSD.set"   = @("InpTF=16386","InpRiskPercent=1.0","InpMagic=770532","InpComment=SW GBPUSD H2")
}
foreach ($nome in $Set.Keys) {
  $Set[$nome] -join "`r`n" | Set-Content -Path (Join-Path $Presets $nome) -Encoding ASCII
  Write-Host ("  scritto: " + $nome) -ForegroundColor Green
}

Write-Host ""
Write-Host "=== PRESET PRONTI. I 5 GRAFICI DA APRIRE (vecchio MT5): ===" -ForegroundColor White
Write-Host "  1. ABTG_PTE       su U30USD  H1  -> Carica VIVAIO_PTE_DOW.set"
Write-Host "  2. ABTG_PTE       su GBPUSD  H1  -> Carica VIVAIO_PTE_GBPUSD.set"
Write-Host "  3. ABTG_PTE       su USDJPY  H1  -> Carica VIVAIO_PTE_USDJPY.set"
Write-Host "  4. ABTG_SuperWave su U30USD  H4  -> Carica VIVAIO_SW_DOW.set   (InpTF resta H2!)"
Write-Host "  5. ABTG_SuperWave su GBPUSD  H4  -> Carica VIVAIO_SW_GBPUSD.set (InpTF resta H2!)"
Write-Host ""
Write-Host "Per ogni grafico: SCREENSHOT degli input PRIMA di dare OK." -ForegroundColor Yellow
Write-Host "A fine deploy: Algo Trading verde, faccine, File -> Profili -> Salva." -ForegroundColor Yellow
