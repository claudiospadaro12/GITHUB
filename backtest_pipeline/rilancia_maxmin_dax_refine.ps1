# =====================================================================
#  rilancia_maxmin_dax_refine.ps1  --  RAFFINAMENTO del DAX night-box
#  SHORT (l'unica direzione/strumento con edge nello screen: PF 1.19).
#  Griglia fine: buffer 7/10/13 pt x SL-ATR 1.5/2.0/2.5 x filtro
#  ampiezza box (0 / salta notti <15 pt) x correlazione S&P on/off.
#  Real tick, rischio 1%. 36 combo.
#  Obiettivo: portarlo a PF >1.3-1.4 con DD basso -> _Ottimizzato.
#  Ripresa: salta se il CSV e' gia' in .\risultati_maxmin_dax_refine\
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_MaxMinNotte"
$Ini="valid_MaxMin_DAX_short_refine"; $Sym="D30EUR"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== RAFFINAMENTO DAX night-box SHORT (real tick) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
foreach($d in @(@{u="$RawBase/mql5/Experts/$EA.mq5";o="src_v2\$EA.mq5"},@{u="$RawBase/backtest_pipeline/ini/$Ini.ini";o="ini\$Ini.ini"})){
  try{Invoke-WebRequest -Uri $d.u -OutFile (Join-Path $Work $d.o) -UseBasicParsing; Write-Host "   OK $($d.o)" -ForegroundColor Green}
  catch{Write-Host "   ERRORE $($d.u): $($_.Exception.Message)" -ForegroundColor Red; exit 1}
}
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
$Results=Join-Path $Work "risultati_maxmin_dax_refine"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
$done=Join-Path $Results "$Ini.csv"
if((Test-Path $done) -and -not $Force){Write-Host "Gia' fatto ($Ini.csv). Usa -Force per rifare." -ForegroundColor DarkGray; exit 0}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$csv=Join-Path $MqlFiles "OptResults_${EA}_${Sym}.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
Write-Host "Ottimizzo DAX short (real tick, 36 combo)..." -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$Ini.ini")`"" -PassThru).WaitForExit()
if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("OK -> risultati_maxmin_dax_refine\$Ini.csv") -ForegroundColor Green}
else{Write-Host "(manca il CSV: MT5 aperto? o compilazione fallita)" -ForegroundColor Yellow}
Write-Host "Mandami il CSV: se il DAX short sale a PF >1.3 con DD basso lo promuoviamo a _Ottimizzato." -ForegroundColor White
