# =====================================================================
#  confronto_fade.ps1  --  UN COMANDO: testa il motore RANGE-FADE
#  (fada gli estremi del range) a TICK REALI su DAX, Nasdaq, Dow.
#  Serve dopo che STOP e RETEST sono stati bocciati (02/08): il fade e'
#  il motore pensato per il WHIPSAW (DAX su e giu' all'apertura).
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_fade.ps1" | iex
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
  Write-Host "!!! MetaTrader e' APERTO: chiudilo e rilancia." -ForegroundColor Red; return
}

$Model=4   # tick reali = la verita'

Write-Host "`n===== 1/2  DAX  RANGE-FADE  =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 3
Write-Host "`n===== 2/2  US (Dow+Nasdaq)  RANGE-FADE  =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 3

Write-Host "`n===== FADE FINITO =====" -ForegroundColor Green
Write-Host "Cartelle sul Desktop: risultati_APERT_DAX_M5_fade_realtick + risultati_APERT_US_M5_fade_realtick" -ForegroundColor White
Write-Host "Zippale e caricamele: confronto fade vs breakout/retest. Barra da battere: PF ~1,3." -ForegroundColor White
