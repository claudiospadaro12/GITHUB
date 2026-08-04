# =====================================================================
#  rilancia_monza.ps1  --  test "stile Monza": aperture con DIREZIONE
#  ADATTIVA (Supertrend Daily) = long nei giorni up, short nei giorni
#  down; candela 5-min pre-apertura; filtro ampiezza 17-40; floor.
#  Spunti dalla live di Emiliano Monza. Niente hedging/martingala.
#  Real tick, rischio 1%. DAX + Nasdaq, prove distinte.
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$Targets=@(
  @{ea="ABTG_DAX_Apertura_EU";    ini="valid_Monza_D30EUR"; sym="D30EUR"},
  @{ea="ABTG_Nasdaq_Apertura_US"; ini="valid_Monza_NASUSD"; sym="NASUSD"}
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== TEST STILE MONZA (direzione adattiva Supertrend D1) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl=@()
foreach($t in $Targets){$dl+=@{u="$RawBase/mql5/Experts/$($t.ea).mq5";o="src_v2\$($t.ea).mq5"};$dl+=@{u="$RawBase/backtest_pipeline/ini/$($t.ini).ini";o="ini\$($t.ini).ini"}}
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
$Results=Join-Path $Work "risultati_monza"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti). Controlla Gestione attivita'." -ForegroundColor Red; exit 1}
$n=0
foreach($t in $Targets){
  $n++
  Copy-Item (Join-Path $Work "src_v2\$($t.ea).mq5") -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($t.ea).mq5")" "/log" | Out-Null
  $csv=Join-Path $MqlFiles "OptResults_$($t.ea)_$($t.sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} stile Monza ..." -f $n,$Targets.Count,$t.sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$($t.ini).ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination (Join-Path $Results "valid_Monza_$($t.sym).csv") -Force; Remove-Item $csv -Force; Write-Host ("        OK -> valid_Monza_{0}.csv" -f $t.sym) -ForegroundColor Green}
  else{Write-Host "        (manca il CSV: MT5 aperto?)" -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i 2 CSV: vediamo se la direzione adattiva (Monza) rende meglio del long fisso." -ForegroundColor White
