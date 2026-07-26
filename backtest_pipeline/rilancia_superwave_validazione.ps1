# =====================================================================
#  rilancia_superwave_validazione.ps1  --  VALIDAZIONE REAL-TICK dei
#  vincenti SuperWave: Dow H1 (primario) + DAX H4 (secondario).
#  Griglia StMult 2.5/3.0/3.5 x TP_RR 2.0/2.5/3.0, rischio 1%.
#  Se confermano -> _Ottimizzato SuperWave per il forward.
#  Ripresa: salta i CSV gia' in .\risultati_superwave_validazione\
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="claude/creating-agents-SgGpD"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_SuperWave"
$Targets=@(
  @{ini="valid_SuperWaveRT_U30USD_H1";sym="U30USD"},   # Dow H1 (primario)
  @{ini="valid_SuperWaveRT_D30EUR_H4";sym="D30EUR"}     # DAX H4 (secondario)
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== VALIDAZIONE REAL-TICK SuperWave (Dow H1, DAX H4) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl=@(@{u="$RawBase/mql5/Experts/$EA.mq5";o="src_v2\$EA.mq5"})
foreach($t in $Targets){$dl+=@{u="$RawBase/backtest_pipeline/ini/$($t.ini).ini";o="ini\$($t.ini).ini"}}
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
$Results=Join-Path $Work "risultati_superwave_validazione"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti). Controlla Gestione attivita'." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$n=0
foreach($t in $Targets){
  $n++
  $done=Join-Path $Results "$($t.ini).csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Targets.Count,$t.ini) -ForegroundColor DarkGray; continue}
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$($t.sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (real tick)..." -f $n,$Targets.Count,$t.ini) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$($t.ini).ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> $($t.ini).csv") -ForegroundColor Green}
  else{Write-Host "        (manca il CSV: MT5 aperto? o senza storico?)" -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i 2 CSV: se confermano creo gli _Ottimizzato SuperWave del Dow H1 (+ DAX H4)." -ForegroundColor White
