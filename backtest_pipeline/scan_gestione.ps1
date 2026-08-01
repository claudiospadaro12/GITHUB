# =====================================================================
#  scan_gestione.ps1  --  STUDIO STRUTTURA DI GESTIONE (BE/parziale/trailing)
#  Trova, a TICK REALI, quale COMBINAZIONE di uscita rende meglio per un
#  EA di apertura M5 (DAX o Nasdaq). Non riscopre l'ingresso: fissa
#  l'ingresso ai default e ottimizza SOLO i toggle di gestione.
#
#  Le strutture testate (48 pass, poi Claude collassa alle ~16 distinte):
#    - Parziale/dimezza:  OFF | 50% a 1R
#    - BE dopo parziale:  OFF | ON
#    - BE indipendente:   OFF | a 1R (InpBEatR)
#    - Trailing:          OFF | ATR | PREVBAR | FIXED
#
#  PC FISSO, MetaTrader CHIUSO.
#
#  Uso:
#    # DAX apertura (server hour 8):
#    .\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU -Symbol D30EUR -SessionHour 8
#    # Nasdaq apertura (server hour 14):
#    .\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US -Symbol NASUSD -SessionHour 14
# =====================================================================
param(
  [string]$Robot="ABTG_DAX_Apertura_EU",
  [string]$Symbol="D30EUR",
  [int]$SessionHour=8,                    # ORA SERVER BCM (DAX=8, Nasdaq=14). NON l'ora italiana!
  [string]$Tf="M5",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA=$Robot
# gli EA con InpBEatR vivono sul branch di lavoro (non ancora sul default)
$EABranch="claude/chat-ea-market-openings-zoba2j"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- GRIGLIA STRUTTURA DI GESTIONE (48 combo; ingresso fissato ai default) ---
#   TrailMode: 0=ATR, 1=PREVBAR, 2=FIXED (l'enum dell'EA)
$Inputs=@"
InpRiskPercent=1.0||1.0||0||1.0||N
InpSessionHour=$SessionHour||$SessionHour||0||$SessionHour||N
InpTP1_R=1.0||1.0||0||1.0||N
InpTP1_ClosePct=0||0||50||50||Y
InpBreakevenAtTP1=0||0||1||1||Y
InpBEatR=0||0||1||1||Y
InpUseTrailing=0||0||1||1||Y
InpTrailMode=0||0||1||2||Y
"@

$EAtag="${EA}_${Symbol}_gestione"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== STUDIO GESTIONE: $EA su $Symbol $Tf (SessionHour SERVER=$SessionHour) a TICK REALI ===" -ForegroundColor Cyan
Write-Host "   48 combinazioni BE/parziale/trailing. Ingresso ai default." -ForegroundColor Gray
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_gest") | Out-Null
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_gest\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_gest\$EA.mq5 (da $EABranch)" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA da $EABranch" -ForegroundColor Red; exit 1}

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
$Results=Join-Path $Work "risultati_gestione"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_gest\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

$iniPath=Join-Path $Work "gestione_${EA}_$Symbol.ini"
@"
[Tester]
Expert=$EA.ex5
Symbol=$Symbol
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
Report=OptReport_$EAtag

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
$csv=Join-Path $MqlFiles "OptResults_${EA}_$Symbol.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
Write-Host "   avvio ottimizzazione 48 combo (TICK REALI M5)... puo' volerci parecchio" -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
$done=Join-Path $Results "gestione_${EAtag}.csv"
if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host "   OK -> $done" -ForegroundColor Green}
else{Write-Host "   (no CSV: simbolo senza storico tick o nome diverso? verifica)" -ForegroundColor Yellow}
Write-Host "`n=== FINITO === Zippa 'risultati_gestione' e caricamela: ti dico quale STRUTTURA di gestione vince per $Symbol." -ForegroundColor White
