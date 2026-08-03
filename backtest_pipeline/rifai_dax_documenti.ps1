# =====================================================================
#  rifai_dax_documenti.ps1  --  RIFA' i due run DAX con la configurazione
#  dei documenti, questa volta con lo STOP GIUSTO.
#
#  PERCHE':
#  i run DAX del 02/08 sono da buttare. Nella configurazione -Doc era
#  rimasto InpSLMode=SL_RANGE (stop sul bordo opposto del range) mentre i
#  livelli erano su D1: il bordo opposto era l'INTERA giornata precedente,
#  quindi stop enorme -> lotto schiacciato al minimo -> P&L insignificante
#  (0,22 EUR di perdita lorda per trade, e un PF 142 che era solo una
#  divisione per quasi-zero).
#  Il PDF dice: "Stop Loss sempre vicino al punto di breakout utilizzando
#  ATR, 5-10 punti sotto/sopra la linea di breakout."
#  Ora -Doc usa InpSLMode=ATR (x1,5), floor 500 punti = 5 punti indice, e
#  InpSkipIfTight=0 (sotto il floor ALLARGA lo stop invece di saltare il
#  trade, cosi' non si taglia il campione).
#
#  ⚠️ IMPORTANTE: gli script SALTANO i simboli gia' fatti. Le due cartelle
#  vecchie contengono risultati INVALIDI: questo script le ARCHIVIA (non le
#  cancella) rinominandole in *_SLRANGE_INVALIDO, cosi' il run riparte
#  davvero e i vecchi numeri restano consultabili.
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#  ⚠️ NON lanciarlo mentre gira l'ablazione: un backtest alla volta.
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/rifai_dax_documenti.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO (o c'e' un backtest in corso): chiudilo e rilancia." -ForegroundColor Red; return
}

# --- archivio le cartelle con i risultati invalidi, altrimenti il run le salta ---
foreach($old in @("risultati_APERT_DAX_M5_doc_brk_realtick","risultati_APERT_DAX_M5_doc_delay_realtick")){
  $p=Join-Path $Work $old
  if(Test-Path $p){
    $dest="${p}_SLRANGE_INVALIDO"
    if(Test-Path $dest){ Remove-Item $dest -Recurse -Force }
    Rename-Item $p $dest
    Write-Host "   archiviata cartella invalida -> $(Split-Path $dest -Leaf)" -ForegroundColor DarkYellow
  }
}

Write-Host "=== Scarico lo script aggiornato ===" -ForegroundColor Cyan
$dax=Join-Path $Work "conferma_apertura_dax.ps1"
irm "$b/conferma_apertura_dax.ps1" -OutFile $dax
Write-Host "   OK" -ForegroundColor Green

Write-Host "`n===== 1/2  DAX  STOP (slide) - stop ATR corretto =====" -ForegroundColor Yellow
& $dax -Model 4 -EntryMode 0 -Doc
Write-Host "`n===== 2/2  DAX  ingresso CONFERMATO (PDF) - stop ATR corretto =====" -ForegroundColor Yellow
& $dax -Model 4 -EntryMode 4 -Doc

Write-Host "`n===== FINITO =====" -ForegroundColor Green
Write-Host "Zippa risultati_APERT_DAX_M5_doc_brk_realtick e ..._doc_delay_realtick e caricamele." -ForegroundColor White
Write-Host "Controllo 1: la perdita lorda per trade deve tornare nell'ordine di 75-100 EUR" -ForegroundColor White
Write-Host "(come il DAX nudo). Se e' ancora sotto 10 EUR, il lotto e' ancora schiacciato." -ForegroundColor White
Write-Host "Controllo 2: i trade. Sotto ~150 il risultato e' sospetto, sotto ~80 non e' un dato." -ForegroundColor White
