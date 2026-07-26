# =====================================================================
#  rilancia_maxmin_indici.ps1  --  SCREEN MaxMinNotte (rottura del range
#  notturno all'apertura europea) su 4 indici EUROPEI: DAX, FTSE, CAC,
#  Stoxx50. Cerca su quale strumento rende meglio.
#  Real tick (e' un breakout: OHLC ingannerebbe), rischio 1%, SL ad ATR.
#  Sweep: direzione (long/short/both) x buffer (5/10/15 punti).
#  Ripresa: salta le prove gia' salvate in .\risultati_maxmin_indici\
#
#  Nota timing: box 23:00-04:59 server, piazza 07:59, cutoff 08:30,
#  chiude 17:30 -> tarato per l'apertura EUROPEA (Francoforte/Londra).
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="claude/creating-agents-SgGpD"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_MaxMinNotte"
$Targets=@(
  @{sym="D30EUR"},   # DAX
  @{sym="100GBP"},   # FTSE 100
  @{sym="F40EUR"},   # CAC 40
  @{sym="E50EUR"}    # Euro Stoxx 50
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== SCREEN MaxMinNotte su indici EUROPEI (DAX/FTSE/CAC/Stoxx50) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl=@(@{u="$RawBase/mql5/Experts/$EA.mq5";o="src_v2\$EA.mq5"})
foreach($t in $Targets){$ini="valid_MaxMin_$($t.sym)"; $dl+=@{u="$RawBase/backtest_pipeline/ini/$ini.ini";o="ini\$ini.ini"}}
foreach($d in $dl){ try{Invoke-WebRequest -Uri $d.u -OutFile (Join-Path $Work $d.o) -UseBasicParsing; Write-Host "   OK $($d.o)" -ForegroundColor Green} catch{Write-Host "   ERRORE $($d.u)" -ForegroundColor Red; exit 1} }
if(-not $Terminal){
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select -First 1}
  else{$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select -First 1}
  if(-not $c){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*"}|Select -First 1}
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|?{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"; $MqlFiles=Join-Path $DataFolder "MQL5\Files"
$Results=Join-Path $Work "risultati_maxmin_indici"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti). Controlla Gestione attivita'." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA -> mandami l'errore da MetaEditor." -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$n=0
foreach($t in $Targets){
  $n++
  $ini="valid_MaxMin_$($t.sym)"
  $done=Join-Path $Results "$ini.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Targets.Count,$t.sym) -ForegroundColor DarkGray; continue}
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$($t.sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (real tick)..." -f $n,$Targets.Count,$t.sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$ini.ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> $ini.csv") -ForegroundColor Green}
  else{Write-Host ("        (manca il CSV: simbolo {0} senza storico? o MT5 aperto?)" -f $t.sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i 4 CSV: vedo se il night-box rende su qualche indice e poi lo perfezioniamo/validiamo." -ForegroundColor White
