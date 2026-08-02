# =====================================================================
#  confronto_ritardata.ps1  --  UN COMANDO: testa il motore
#  ENTRATA RITARDATA / CONFERMATA (motore #4+#6 del menu caccia)
#  a TICK REALI su DAX, Nasdaq, Dow.
#
#  Perche': all'apertura c'e' rumore. Lo STOP breakout paga slippage
#  (Nasdaq 0,88 · DAX 0,77) e il RETEST e' selezione avversa (bocciato
#  02/08). Qui si ASPETTA che il mercato scelga, poi si entra A MERCATO
#  dalla parte giusta: nessuno stop da inseguire = nessuno slippage di
#  rottura.
#
#  La griglia gira da sola su:
#    - ATTESA:    15 / 30 / 45 minuti dall'apertura
#    - DIREZIONE: 0=break (fuori dal range)  1=mid (sopra/sotto il centro)
#                 2=candela (corpo della candela di apertura, first-candle)
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_ritardata.ps1" | iex
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

Write-Host "`n===== 1/2  DAX  ENTRATA RITARDATA  =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 4
Write-Host "`n===== 2/2  US (Dow+Nasdaq)  ENTRATA RITARDATA  =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 4

Write-Host "`n===== RITARDATA FINITA =====" -ForegroundColor Green
Write-Host "Cartelle sul Desktop: risultati_APERT_DAX_M5_delay_realtick + risultati_APERT_US_M5_delay_realtick" -ForegroundColor White
Write-Host "Zippale e caricamele: confronto ritardata vs breakout/retest/fade. Barra da battere: PF ~1,3." -ForegroundColor White
