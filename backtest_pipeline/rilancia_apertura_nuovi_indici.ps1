# =====================================================================
#  rilancia_apertura_nuovi_indici.ps1  --  APERTURA su nuovi indici
#  (consiglio di Marco): FTSE UK100 (mattina ora 8), Russell US2000 e
#  Dow US30 (pomeriggio ora 14:30). Marco: Russell/Dow > Nasdaq.
#  Real tick, rischio 1%. Varia direzione (long/short/both) e buffer.
#  Ripresa: salta le prove gia' salvate.
#
#  !! IMPORTANTE: i simboli UK100 / US2000 / US30 devono essere nella
#  tua Market Watch BCM (tasto destro > Mostra tutto, oppure cerca).
#  Se il nome sul tuo broker e' diverso, dimmelo e correggo gli .ini.
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="claude/creating-agents-SgGpD"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_DAX_Apertura_EU"
$Targets=@(
  @{ini="valid_Apertura_UK100"; sym="UK100"},
  @{ini="valid_Apertura_US2000";sym="US2000"},
  @{ini="valid_Apertura_US30";  sym="US30"}
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== APERTURA su NUOVI INDICI (UK100 / Russell US2000 / Dow US30) ===" -ForegroundColor Cyan
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
$Results=Join-Path $Work "risultati_apertura_nuovi_indici"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti). Controlla Gestione attivita'." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
$n=0
foreach($t in $Targets){
  $n++
  $done=Join-Path $Results "valid_Apertura_$($t.sym).csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Targets.Count,$t.sym) -ForegroundColor DarkGray; continue}
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$($t.sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (real tick)..." -f $n,$Targets.Count,$t.sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$($t.ini).ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> valid_Apertura_{0}.csv" -f $t.sym) -ForegroundColor Green}
  else{Write-Host ("        (manca il CSV: simbolo {0} non in Market Watch? o MT5 aperto?)" -f $t.sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i CSV: vediamo se Russell/Dow/UK100 in apertura battono il Nasdaq (come dice Marco)." -ForegroundColor White
