# =====================================================================
#  allinea_nasdaq_volumi.ps1 -- preset ALLINEAMENTO Nasdaq base (12/08)
#  Accende il filtro volumi sul grafico vivo (decisione R25, misura R24):
#  UNICHE differenze dal grafico attuale: UseVolumeFilter=true e
#  ConfirmMode=AND. Tutto il resto = config misurata (verificata riga
#  per riga sugli screenshot del 12/08, rischio resta 0.25, magic 770201).
#  Si lancia SUL VPS. MT5 puo' restare aperto.
#
#  DOPO lo script, sul vecchio MT5 (conto 50503392):
#   1. grafico NASUSD M5 con ABTG_Nasdaq_Apertura_US -> F7;
#   2. Carica -> ALLINEA_NASDAQ_VOLUMI.set;
#   3. SCREENSHOT prima di OK (controllo: volumi true, AND, rischio 0.25,
#      magic 770201) -> verifica di Claude -> OK;
#   4. File -> Profili -> Salva Profilo (ORO).
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }

$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null

# Config completa v1.00 = misura R24/R30 baseline, con rischio live 0.25
# e le DUE modifiche autorizzate (volumi ON, conferma AND).
@(
  "; ALLINEA_NASDAQ_VOLUMI -- generato 12/08 da referto R25/R30",
  "InpSessionHour=14",
  "InpSessionMin=30",
  "InpRangeMinutes=15",
  "InpCloseHour=21",
  "InpCloseMin=45",
  "InpCloseAtEnd=true",
  "InpOneTradePerDay=true",
  "InpMaxPosSimbolo=0",
  "InpEntryMode=0",
  "InpRangeMode=2",
  "InpLevelTF=16385",
  "InpPrevWindowMin=60",
  "InpBufferPoints=200.0",
  "InpOCTimeframe=0",
  "InpPendingExpiryMin=120",
  "InpAllowLong=true",
  "InpAllowShort=true",
  "InpMinRangePts=0.0",
  "InpMaxRangePts=0.0",
  "InpRetestOffsetPts=0.0",
  "InpFadeOffsetPts=0.0",
  "InpDelayMinutes=30",
  "InpDelayDirMode=0",
  "InpUseGapFill=false",
  "InpGapMinPoints=150.0",
  "InpGapMinRR=1.5",
  "InpUseEmaFilter=false",
  "InpEmaFast=14",
  "InpEmaSlow=200",
  "InpFilterTF=16385",
  "InpUseSupertrend=false",
  "InpStAtrPeriod=10",
  "InpStMultiplier=2.5",
  "InpStTF=16385",
  "InpUseSupertrend3=false",
  "InpUseCorrelation=false",
  "InpCorrSymbol=SPXUSD",
  "InpCorrTF=16385",
  "InpCorrEmaFast=14",
  "InpCorrEmaSlow=100",
  "InpUseVwapFilter=false",
  "InpVwapTF=15",
  "InpRiskPercent=0.25",
  "InpSLMode=0",
  "InpAtrSlMult=1.5",
  "InpAtrPeriodMgmt=14",
  "InpTP1_R=1.0",
  "InpTP1_ClosePct=50.0",
  "InpBreakevenAtTP1=true",
  "InpBEatR=0.0",
  "InpUseTrailing=true",
  "InpTrailStartR=0.0",
  "InpTrailMode=1",
  "InpTrailTF=1",
  "InpTrailAtrMult=2.0",
  "InpTrailFixedPts=410.0",
  "InpUseRoundLevels=false",
  "InpRoundStep=100.0",
  "InpRoundMinDistPts=50.0",
  "InpUseNewsFilter=false",
  "InpNewsFile=abtg_news.csv",
  "InpNewsMinImpact=3",
  "InpNewsBeforeMin=30",
  "InpNewsAfterMin=30",
  "InpNewsShiftMinutes=0",
  "InpNewsCurrencies=",
  "InpNewsFlatten=true",
  "InpSlippagePts=0.0",
  "InpMinStopPts=0.0",
  "InpSkipIfTight=true",
  "InpUseVolumeFilter=true",
  "InpVolMult=1.5",
  "InpVolAvgBars=20",
  "InpUseAtrFilter=false",
  "InpAtrFilterBars=20",
  "InpAtrFilterMult=1.0",
  "InpConfirmMode=1",
  "InpMagic=770201",
  "InpMaxSpread=0",
  "InpVerbose=true"
) -join "`r`n" |
  Set-Content -Path (Join-Path $Presets "ALLINEA_NASDAQ_VOLUMI.set") -Encoding ASCII

Write-Host "OK: scritto ALLINEA_NASDAQ_VOLUMI.set" -ForegroundColor Green
Write-Host ""
Write-Host "=== ADESSO SUL VECCHIO MT5 (50503392): ===" -ForegroundColor White
Write-Host "  grafico NASUSD M5 -> F7 -> Carica -> ALLINEA_NASDAQ_VOLUMI.set"
Write-Host "  SCREENSHOT prima di OK. Controlli chiave:" -ForegroundColor Yellow
Write-Host "   - 'Entra solo se il volume della rottura supera la media' = true"
Write-Host "   - 'Se volumi E ATR...' = ENTRAMBE (AND)"
Write-Host "   - 'Rischio per trade in %' = 0.25"
Write-Host "   - 'Numero magico' = 770201"
Write-Host "  Poi OK -> File -> Profili -> Salva Profilo (ORO)." -ForegroundColor Yellow
