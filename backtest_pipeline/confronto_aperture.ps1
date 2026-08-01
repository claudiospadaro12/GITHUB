# =====================================================================
#  confronto_aperture.ps1  --  UN SOLO COMANDO, FA TUTTO
#  Scarica gli script aggiornati e lancia in fila tutti e 4 i backtest
#  a TICK REALI, per confrontare il MOTORE d'ingresso STOP vs RETEST:
#     1) US  (Dow + Nasdaq)  STOP        3) DAX  STOP
#     2) US  (Dow + Nasdaq)  RETEST      4) DAX  RETEST
#
#  Lancia con UNA riga (niente cd, niente execution policy):
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_aperture.ps1" | iex
#
#  ATTENZIONE: MetaTrader deve essere CHIUSO. A tick reali sono ore:
#  fallo partire e lascialo lavorare. Alla fine: 4 cartelle sul Desktop.
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

Write-Host "=== Scarico gli script aggiornati in $Work ===" -ForegroundColor Cyan
$us =Join-Path $Work "conferma_apertura_us.ps1"
$dax=Join-Path $Work "conferma_apertura_dax.ps1"
irm "$b/conferma_apertura_us.ps1"  -OutFile $us
irm "$b/conferma_apertura_dax.ps1" -OutFile $dax
Write-Host "   OK" -ForegroundColor Green

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO: chiudilo e rilancia (senno' 0 risultati)." -ForegroundColor Red
  return
}

$Model=4   # tick reali = la verita' sui fill (STOP paga slippage, RETEST no)

Write-Host "`n===== 1/4  US (Dow+Nasdaq)  STOP  =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 0
Write-Host "`n===== 2/4  US (Dow+Nasdaq)  RETEST  =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 2
Write-Host "`n===== 3/4  DAX  STOP  =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 0
Write-Host "`n===== 4/4  DAX  RETEST  =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 2

Write-Host "`n===== TUTTO FINITO =====" -ForegroundColor Green
Write-Host "4 cartelle sul Desktop:" -ForegroundColor White
Write-Host "  risultati_APERT_US_M5_brk_realtick     (US  STOP)"   -ForegroundColor White
Write-Host "  risultati_APERT_US_M5_retest_realtick  (US  RETEST)" -ForegroundColor White
Write-Host "  risultati_APERT_DAX_M5_brk_realtick    (DAX STOP)"   -ForegroundColor White
Write-Host "  risultati_APERT_DAX_M5_retest_realtick (DAX RETEST)" -ForegroundColor White
Write-Host "Zippale tutte e 4 e caricamele nella chat." -ForegroundColor White
