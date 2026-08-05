# =====================================================================
#  goldencross_lavorenti.ps1  --  la regola delle candele HA, misurata
#
#  Claudio (05/08): "la Golden Cross dovrebbe essere una strategia che
#  entra solo quando si incrociano EMA 9 e 21 e c'e' la conferma anche
#  delle due candele Heiken Ashi senza stoppino. Da 5 a 15 min servono
#  3 candele senza stoppino, da TF 15 min in su ne bastano due. Lo dice
#  spesso Paolo Lavorenti. Probabilmente anche le bande di Bollinger
#  che si espandono potrebbe essere un segnale positivo."
#
#  L'EA faceva GIA' quasi tutto questo. Ma su due punti NON seguiva la
#  regola, e girava su H1:
#
#    | | Lavorenti | ABTG_GoldenCross |
#    | candele HA su H1  | 2 bastano | ne chiedeva 3        |
#    | "senza stoppino"  | zero      | tollerava il 30% del corpo |
#
#  Il primo punto pesa: su H1 pretendere la terza candela vuol dire
#  entrare UN'ORA dopo, e su un incrocio di medie l'ora dopo il prezzo
#  se n'e' gia' andato. Il secondo e' piu' sottile: "ombra fino al 30%
#  del corpo" e' un'altra cosa da "senza stoppino".
#
#  Qui si misura, invece di deciderlo a parole. In sweep SOLO le tre
#  cose in discussione:
#     InpHACount       2 / 3            (la regola di Lavorenti)
#     InpHAWickRatio   0 / 0,15 / 0,30  (quanto stretto e' "senza stoppino")
#     InpUseBBExpand   0 / 1            (l'intuizione sulle Bollinger)
#  12 pass per simbolo. Tutto il resto INCHIODATO ai default.
#
#  Simboli: ORO e DAX, come chiesto da Claudio ("su Golden Cross non e'
#  meglio trovare oro o DAX + che altri simboli?").
#
#  ⚠️ Da lanciare DOPO notte_05-08.ps1: due ottimizzazioni insieme si
#     rubano la CPU e falsano i tempi.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\goldencross_lavorenti.ps1
#    .\goldencross_lavorenti.ps1 -Symbols XAUUSD -Tf M15
# =====================================================================
param(
  [string[]]$Symbols=@("XAUUSD","D30EUR"),
  [string]$Tf="H1",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_GoldenCross"
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$tfmap=@{ "M5"=5; "M15"=15; "M30"=30; "H1"=16385; "H4"=16388; "D1"=16408 }
if(-not $tfmap.ContainsKey($Tf)){ Write-Host "Timeframe $Tf non riconosciuto." -ForegroundColor Red; exit 1 }
$tfVal=$tfmap[$Tf]

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== GOLDEN CROSS: la regola delle candele HA, a tick reali ===" -ForegroundColor Cyan
Write-Host "    Sweep: HACount 2/3 x WickRatio 0/0,15/0,30 x Bollinger OFF/ON" -ForegroundColor Gray
Write-Host "    $($Symbols.Count) simboli x 12 pass su $Tf." -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_gc_lavorenti"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_gcl")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

$src=Join-Path $Work "src_gcl\$EA.mq5"
try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile $src -UseBasicParsing
     Write-Host "    scaricato $EA.mq5 (da $EABranch)" -ForegroundColor Green }
catch{ Write-Host "    ERRORE download $EA" -ForegroundColor Red; exit 1 }
Copy-Item $src -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){ Write-Host "    ERRORE compilazione" -ForegroundColor Red; exit 1 }
Write-Host "    compilato" -ForegroundColor Green

foreach($sym in $Symbols){
  Write-Host ""
  Write-Host "--- $sym su $Tf ---" -ForegroundColor Cyan

  # InpHAAutoCount resta FALSE: qui si spazzola InpHACount a mano, cosi' si
  # misura la regola invece di applicarla a scatola chiusa. Se il 2 vince su
  # H1, la regola di Lavorenti e' confermata e si accende l'automatismo.
  $Inputs=@"
InpTimeframe=$tfVal||$tfVal||0||$tfVal||N
InpEmaFast=9||9||0||9||N
InpEmaMid=21||21||0||21||N
InpEmaSlow=50||50||0||50||N
InpEmaSlopeBars=3||3||0||3||N
InpRequireAlignment=1||1||0||1||N
InpCrossLookback=8||8||0||8||N
InpHAAutoCount=0||0||0||0||N
InpHABodyFactor=0.60||0.60||0||0.60||N
InpBBPeriod=20||20||0||20||N
InpBBDev=2.0||2.0||0||2.0||N
InpBBExpandBars=3||3||0||3||N
InpBBExpandMult=1.05||1.05||0||1.05||N
InpAdxPeriod=14||14||0||14||N
InpAdxMin=20.0||20.0||0||20.0||N
InpAdxRising=1||1||0||1||N
InpRequireDI=1||1||0||1||N
InpMaxDistATR=1.5||1.5||0||1.5||N
InpMinRR=1.0||1.0||0||1.0||N
InpEntryMode=0||0||0||0||N
InpPendingExpiryBars=3||3||0||3||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpSLMode=0||0||0||0||N
InpSwingLookback=10||10||0||10||N
InpAtrPeriod=14||14||0||14||N
InpAtrSLmult=1.5||1.5||0||1.5||N
InpSLBufferPts=0||0||0||0||N
InpTP_R=2.0||2.0||0||2.0||N
InpPartialR=1.0||1.0||0||1.0||N
InpPartialPct=50||50||0||50||N
InpBreakeven=1||1||0||1||N
InpTrailMode=0||0||0||0||N
InpTrailAtrMult=2.0||2.0||0||2.0||N
InpExitOnCross=1||1||0||1||N
InpExitOnHAflip=0||0||0||0||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpMaxTradesPerDay=2||2||0||2||N
InpStopAfterLosses=2||2||0||2||N
InpUseNewsFilter=0||0||0||0||N
InpHACount=3||2||1||3||Y
InpHAWickRatio=0.30||0.0||0.15||0.30||Y
InpUseBBExpand=0||0||1||1||Y
"@

  $tag="gc_${sym}_$Tf"
  $ini=Join-Path $Work "gcl_$tag.ini"
@"
[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=$Tf
Model=4
Optimization=1
OptimizationCriterion=6
FromDate=2024.01.01
ToDate=2026.06.30
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag

[TesterInputs]
$Inputs
"@ | Set-Content -Path $ini -Encoding ASCII

  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  Write-Host "    avvio 12 pass (TICK REALI $Tf, 2024.01 - 2026.06)..." -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  $done=Join-Path $Results "$tag.csv"
  if(Test-Path $csv){
    try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
         Write-Host "    OK -> $done" -ForegroundColor Green }
    catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
  }else{
    Write-Host "    (nessun CSV per ${tag}: storico tick mancante su $sym?)" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "=== FINITO === Zippa 'risultati_gc_lavorenti' e caricamela." -ForegroundColor White
Write-Host "    La domanda a cui rispondono: su H1 bastano DUE candele HA?" -ForegroundColor Gray
