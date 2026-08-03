# =====================================================================
#  confronto_aperture_veloce.ps1  --  PROVA VELOCE (OHLC, pochi minuti)
#  Serve SOLO a vedere quanti trade fa il RETEST rispetto allo STOP.
#  NON decide (la verita' sui fill e' solo a tick reali): se il RETEST
#  fa pochissimi trade -> il "ritorno sul livello" non arriva -> inutile
#  perdere una notte col tick reali. Se i numeri sono sensati -> lanci
#  poi confronto_aperture.ps1 (tick reali).
#
#  ⚠️ SUL PC DI BACKTEST (PC fisso), NON sul VPS. MetaTrader CHIUSO.
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/confronto_aperture_veloce.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

Write-Host "=== PROVA VELOCE OHLC (conta i trade STOP vs RETEST) in $Work ===" -ForegroundColor Cyan
$us =Join-Path $Work "conferma_apertura_us.ps1"
$dax=Join-Path $Work "conferma_apertura_dax.ps1"
irm "$b/conferma_apertura_us.ps1"  -OutFile $us
irm "$b/conferma_apertura_dax.ps1" -OutFile $dax
Write-Host "   OK script scaricati" -ForegroundColor Green

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO: chiudilo e rilancia." -ForegroundColor Red
  return
}

$Model=1   # OHLC veloce (solo per contare i trade, non per decidere)

Write-Host "`n===== 1/4  US (Dow+Nasdaq)  STOP  (OHLC) =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 0
Write-Host "`n===== 2/4  US (Dow+Nasdaq)  RETEST  (OHLC) =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 2
Write-Host "`n===== 3/4  DAX  STOP  (OHLC) =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 0
Write-Host "`n===== 4/4  DAX  RETEST  (OHLC) =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 2

Write-Host "`n===== PROVA VELOCE FINITA =====" -ForegroundColor Green
Write-Host "4 cartelle sul Desktop (..._brk_ohlc / ..._retest_ohlc, US e DAX)." -ForegroundColor White
Write-Host "Zippale e caricamele: guardo il NUMERO DI TRADE del RETEST." -ForegroundColor White
Write-Host "Se il RETEST fa abbastanza trade -> vale la pena il tick reali (confronto_aperture.ps1)." -ForegroundColor White
