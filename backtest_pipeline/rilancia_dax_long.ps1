# =====================================================================
#  rilancia_dax_long.ps1  --  re-test DAX Apertura SOLO-LONG, Supertrend
#  OFF, ora 8 (config "come il nativo"), real tick. L'ultimo controllo
#  onesto prima di seppellire l'aperture DAX.
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="claude/creating-agents-SgGpD"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$ea="ABTG_DAX_Apertura_EU"; $ini="valid_DAX_Apertura_LONG"; $sym="D30EUR"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== RE-TEST DAX APERTURA SOLO-LONG (ora 8, ST off) ===" -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
foreach($d in @(@{u="$RawBase/mql5/Experts/$ea.mq5";o="src_v2\$ea.mq5"},@{u="$RawBase/backtest_pipeline/ini/$ini.ini";o="ini\$ini.ini"})){
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
$Results=Join-Path $Work "risultati_validazione_aperture"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$ea.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$ea.mq5")" "/log" | Out-Null
$old=Join-Path $MqlFiles "OptResults_${ea}_${sym}.csv"; if(Test-Path $old){Remove-Item $old -Force}
Write-Host "Ottimizzo (real tick)..." -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$ini.ini")`"" -PassThru).WaitForExit()
if(Test-Path $old){Copy-Item $old -Destination (Join-Path $Results "valid_DAX_Apertura_LONG_${sym}.csv") -Force; Write-Host "OK -> risultati_validazione_aperture\valid_DAX_Apertura_LONG_${sym}.csv" -ForegroundColor Green}
else{Write-Host "(manca il CSV)" -ForegroundColor Yellow}
Write-Host "Mandami il CSV." -ForegroundColor White
