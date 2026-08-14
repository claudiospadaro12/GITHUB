# =====================================================================
#  walkforward.ps1  --  ULTIMO CANCELLO anti-overfit sui FINALISTI prop.
#
#  Per ciascun finalista lancia la STESSA griglia su DUE finestre:
#    IS  (in-sample):     2024.01.01 - 2025.06.30  (ottimizzo qui)
#    OOS (out-of-sample): 2025.07.01 - 2026.06.30  (verifico qui)
#  Se i parametri ROBUSTI dell'IS restano buoni anche in OOS -> l'edge
#  e' stabile nel tempo (non curve-fittato). Se in OOS crolla -> overfit.
#
#  Finalisti: Oro (SupRev H4, LONG) + USDCHF (GoldenCross H4, BOTH).
#  PC FISSO, MT5 CHIUSO. Default Model 1 (OHLC, veloce); -Model 4 tick reali.
#
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\walkforward.ps1
#    .\walkforward.ps1 -Model 4        (piu' lento, fill veri)
# =====================================================================
param(
  [int]$Model=1,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- FINALISTI (EA + simbolo + griglia focalizzata sulla zona robusta) ---
$Jobs=@(
  @{ Name="ORO"; EA="ABTG_SupertrendReversal"; Sym="XAUUSD"; Period="H4"; Inputs=@"
InpTF=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpStAtrPeriod=10||10||0||10||N
InpAllowLong=1||1||0||1||N
InpAllowShort=0||0||0||1||N
InpStMult=2.5||2.0||0.5||3.5||Y
InpTP_RR=2.5||2.0||0.5||3.0||Y
"@ },
  @{ Name="USDCHF"; EA="ABTG_GoldenCross"; Sym="USDCHF"; Period="H4"; Inputs=@"
InpTimeframe=16388||16388||0||16388||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpTP_R=2.5||1.5||0.5||3.0||Y
InpAtrSLmult=1.5||1.0||0.5||2.0||Y
InpAdxMin=25||20||5||25||Y
"@ }
)
$Windows=@(
  @{ Tag="IS";  From="2024.01.01"; To="2025.06.30" },
  @{ Tag="OOS"; From="2025.07.01"; To="2026.06.30" }
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== WALK-FORWARD (IS vs OOS, Model $Model) sui finalisti ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_wf") | Out-Null

# --- trova terminale/metaeditor/cartella dati ---
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
$Results=Join-Path $Work "risultati_walkforward"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima." -ForegroundColor Red; exit 1}

# --- scarica e compila gli EA (una volta per EA) ---
$doneEA=@{}
foreach($job in $Jobs){
  if($doneEA.ContainsKey($job.EA)){continue}
  try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($job.EA).mq5" -OutFile (Join-Path $MqlExperts "$($job.EA).mq5") -UseBasicParsing}
  catch{Write-Host "   ERRORE download $($job.EA)" -ForegroundColor Red; exit 1}
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($job.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($job.EA).ex5"))){Write-Host "ERRORE compilazione $($job.EA)" -ForegroundColor Red; exit 1}
  Write-Host "   compilato $($job.EA).ex5" -ForegroundColor Green
  $doneEA[$job.EA]=$true
}

foreach($job in $Jobs){
  foreach($w in $Windows){
    $done=Join-Path $Results "wf_$($w.Tag)_$($job.Name).csv"
    if(Test-Path $done){Write-Host "   $($job.Name) $($w.Tag): gia' fatto, salto" -ForegroundColor DarkGray; continue}
    $iniPath=Join-Path $Work "ini_wf\wf_$($job.Name)_$($w.Tag).ini"
    @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($job.EA).ex5
Symbol=$($job.Sym)
Period=$($job.Period)
Model=$Model
Optimization=2
OptimizationCriterion=6
FromDate=$($w.From)
ToDate=$($w.To)
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_wf_$($job.Name)_$($w.Tag)

[TesterInputs]
$($job.Inputs)
"@ | Set-Content -Path $iniPath -Encoding ASCII
    $csv=Join-Path $MqlFiles "OptResults_$($job.EA)_$($job.Sym).csv"; if(Test-Path $csv){Remove-Item $csv -Force}
    Write-Host "   $($job.Name) $($w.Tag) ($($w.From)->$($w.To))..." -ForegroundColor Cyan
    (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
    if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host "        OK -> wf_$($w.Tag)_$($job.Name).csv" -ForegroundColor Green}
    else{Write-Host "        (no CSV: verifica storico/nome simbolo)" -ForegroundColor Yellow}
  }
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa risultati_walkforward e caricamela: confronto IS vs OOS e ti dico se l'edge e' stabile." -ForegroundColor White
