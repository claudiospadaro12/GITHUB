# =====================================================================
#  sweep_volumi_nasdaq.ps1  --  IL GINOCCHIO DELLA CURVA DEI VOLUMI
#
#  L'ablazione del 02/08 ha trovato l'edge: e' il FILTRO VOLUMI. La curva
#  e' monotona (piu' stringi, piu' sale il PF e scende il DD), ma la
#  griglia salta da 1,5 a 1,8 e nessuna delle due soglie passa i criteri:
#
#     volumi >= 1,2x  ->  296 trade (47% dei giorni)  PF 0,96  DD 18%
#     volumi >= 1,5x  ->  152 trade (24%)             PF 1,15  DD 9,6%   <- campione ok, PF basso
#     volumi >= 1,8x  ->   79 trade (13%)             PF 1,38  DD 7,6%   <- PF ok, campione scarso
#
#  Criteri (fissati PRIMA del test): trade >= 150  E  PFmed >= 1,3.
#  Questo sweep campiona 1,5 / 1,6 / 1,7 / 1,8 / 1,9 / 2,0 per vedere se
#  il punto utile esiste in mezzo.
#
#  COME SI LEGGE:
#   - esiste una soglia con >=150 trade e PF >=1,3   -> CANDIDATO VERO, si va avanti
#   - il PF sale solo mentre i trade crollano         -> l'edge c'e' ma e' troppo raro:
#                                                        non ci si costruisce un EA sopra
#   - il PF smette di salire oltre una soglia         -> oltre li' e' rumore, non informazione
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO.
#  ⚠️ Un backtest alla volta: aspetta che l'ablazione sia finita.
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/sweep_volumi_nasdaq.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO (o c'e' un backtest in corso): chiudilo e rilancia." -ForegroundColor Red; return
}

Write-Host "=== Scarico lo script aggiornato in $Work ===" -ForegroundColor Cyan
$us=Join-Path $Work "conferma_apertura_us.ps1"
irm "$b/conferma_apertura_us.ps1" -OutFile $us
Write-Host "   OK" -ForegroundColor Green

Write-Host "`n===== SWEEP VOLUMI 1,5 -> 2,0 (solo filtro volumi) =====" -ForegroundColor Yellow
& $us -Model 4 -EntryMode 0 -Doc -Filters "vol" -Symbols NASUSD -VolSweep

Write-Host "`n===== FINITO =====" -ForegroundColor Green
Write-Host "Cartella: risultati_APERT_US_M5_doc_brk_vol_sweep_realtick" -ForegroundColor White
Write-Host "(nome DIVERSO dall'ablazione -> nessuna collisione, nessun simbolo saltato)." -ForegroundColor White
Write-Host "Zippala e caricamela." -ForegroundColor White
