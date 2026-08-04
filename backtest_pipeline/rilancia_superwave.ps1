# =====================================================================
#  rilancia_superwave.ps1  --  SCREEN del nuovo EA SuperWave
#  (ingresso = incrocio EMA14 x EMA200 a favore del Supertrend, dalla
#  dashboard SuperWave). Trend-following: lo provo su oro, DAX, Dow,
#  Nasdaq su H1 e H4. Screen OHLC (affidabile su H1/H4), rischio 1%.
#  Griglia: StMult 2.5/3.0/3.5 x TP_RR 2.0/2.5/3.0, entrambe le direzioni.
#  I vincitori poi si validano in real-tick.
#  Ripresa: salta le prove gia' salvate in .\risultati_superwave\
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_SuperWave"
$Targets=@(
  @{sym="XAUUSD";tf="H1"}, @{sym="XAUUSD";tf="H4"},   # Oro
  @{sym="D30EUR";tf="H1"}, @{sym="D30EUR";tf="H4"},   # DAX
  @{sym="U30USD";tf="H1"}, @{sym="U30USD";tf="H4"},   # Dow
  @{sym="NASUSD";tf="H1"}, @{sym="NASUSD";tf="H4"}    # Nasdaq
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== SCREEN SuperWave (cross EMA14x200 + Supertrend) su oro/DAX/Dow/Nasdaq H1+H4 ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl=@(@{u="$RawBase/mql5/Experts/$EA.mq5";o="src_v2\$EA.mq5"})
foreach($t in $Targets){$ini="valid_SuperWave_$($t.sym)_$($t.tf)"; $dl+=@{u="$RawBase/backtest_pipeline/ini/$ini.ini";o="ini\$ini.ini"}}
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
$Results=Join-Path $Work "risultati_superwave"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti). Controlla Gestione attivita'." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA -> mandami l'errore da MetaEditor." -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$n=0
foreach($t in $Targets){
  $n++
  $ini="valid_SuperWave_$($t.sym)_$($t.tf)"
  $done=Join-Path $Results "$ini.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2} {3}: gia' fatto, salto" -f $n,$Targets.Count,$t.sym,$t.tf) -ForegroundColor DarkGray; continue}
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$($t.sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} {3} (OHLC screen)..." -f $n,$Targets.Count,$t.sym,$t.tf) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$ini.ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> $ini.csv") -ForegroundColor Green}
  else{Write-Host ("        (manca il CSV: simbolo {0} senza storico? o MT5 aperto?)" -f $t.sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i CSV: scelgo i vincenti (PF>1.2, abbastanza trade) e li validiamo in real-tick." -ForegroundColor White
