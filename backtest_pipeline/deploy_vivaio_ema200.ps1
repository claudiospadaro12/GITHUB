# =====================================================================
#  deploy_vivaio_ema200.ps1 -- preset del VIVAIO EMA200 DOW (12/08)
#  Sedia 12 (R29 primo 30/30 + R31 portafoglio). Referto:
#  risultati_archivio/REFERTO_ROUND31_EMA200_PORTAFOGLIO.md
#  Si lancia SUL VPS. MT5 puo' restare aperto.
#
#  DOPO lo script:
#   1. vecchio MT5: apri il grafico U30USD H1;
#   2. trascina ABTG_EMA200 dal Navigatore (l'ex5 c'e': la pulizia ha
#      tolto i grafici, non la libreria);
#   3. Parametri di input -> Carica -> VIVAIO_EMA200_DOW.set;
#   4. SCREENSHOT prima di OK -> verifica; poi File -> Profili -> Salva.
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }

$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null

# cella CENTRO del walk-forward R29 (mai il best): H1, O1 0,20 / O2 0,3 / TP 2R
@("InpTF=16385",
  "InpOrder1Atr=0.20",
  "InpOrder2Atr=0.3",
  "InpTP_RR=2.0",
  "InpRiskPercent=1.0",
  "InpMagic=771531",
  "InpComment=EMA200 DOW") -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "VIVAIO_EMA200_DOW.set") -Encoding ASCII

Write-Host "OK: scritto VIVAIO_EMA200_DOW.set" -ForegroundColor Green
Write-Host ""
Write-Host "=== IL GRAFICO DA APRIRE (vecchio MT5): ===" -ForegroundColor White
Write-Host "  ABTG_EMA200 su U30USD H1 -> Carica VIVAIO_EMA200_DOW.set"
Write-Host "  (magic 771531, commento 'EMA200 DOW', rischio 1.0)"
Write-Host ""
Write-Host "SCREENSHOT degli input PRIMA di dare OK; poi Salva profilo." -ForegroundColor Yellow
