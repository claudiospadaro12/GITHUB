# =====================================================================
#  conferma_apertura_us.ps1  --  CONFERMA col motore APERTURA REALE
#  (ABTG_Nasdaq_Apertura_US) i preset Dow/Nasdaq col filtro H4.
#
#  Lo studio (ABTG_Apertura_Study_EA) usa un TP fisso 2R; l'EA vero ha
#  parziale + break-even + trailing. Qui verifichiamo che l'edge regga
#  con la gestione REALE, su U30USD e NASUSD, in M5.
#
#  Filtro H4 = prezzo vs EMA50 su H4 (EmaFast=1 ~ prezzo, EmaSlow=50),
#  identico allo studio. Mini-griglia sul buffer (100/200/300/400) per
#  vedere quanto e' sensibile.
#
#  PC FISSO, MetaTrader CHIUSO. Ripresa: salta i simboli gia' fatti.
#
#  Uso (default = OHLC veloce, BREAKOUT attuale):
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_us.ps1
#  A TICK REALI (piu' lento, la verita' sui fill dei breakout):
#    .\conferma_apertura_us.ps1 -Model 4
#
#  CONFRONTO MOTORE (la vera domanda: limit batte lo stop?):
#    STOP  (attuale):  .\conferma_apertura_us.ps1 -Model 4 -EntryMode 0
#    RETEST (Emiliano): .\conferma_apertura_us.ps1 -Model 4 -EntryMode 2
#    -> due set di CSV separati (..._brk_... vs ..._retest_...), poi si confrontano.
#    (RETEST = rottura + ritorno sul livello con LIMIT: niente slippage, SL piu' stretto.)
# =====================================================================
param(
  [string[]]$Symbols=@("U30USD","NASUSD"),
  [int]$Model=1,                              # 1=OHLC (veloce) · 4=tick reali (verita')
  [int]$EntryMode=0,                          # 0=BREAKOUT (stop, attuale) · 2=RETEST (limit, leva Emiliano)
  [double]$RetestOffset=0,                     # (solo RETEST) offset del limit DENTRO il livello, in punti
  [string]$EABranch="claude/chat-ea-market-openings-zoba2j", # branch con l'EA aggiornato (RETEST)
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_Nasdaq_Apertura_US"                 # motore US (symbol-agnostico)
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- INPUT: preset apertura + filtro H4 acceso; buffer in mini-griglia ---
$Inputs=@"
InpSessionHour=14||14||0||14||N
InpSessionMin=30||30||0||30||N
InpUseEmaFilter=1||1||0||1||N
InpFilterTF=16388||16388||0||16388||N
InpEmaFast=1||1||0||1||N
InpEmaSlow=50||50||0||50||N
InpUseSupertrend=0||0||0||0||N
InpUseCorrelation=0||0||0||0||N
InpUseVwapFilter=0||0||0||0||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpBufferPoints=200||100||100||400||Y
"@

# --- modalita' d'ingresso: BREAKOUT (stop) vs RETEST (limit) ---
$Inputs += "`nInpEntryMode=$EntryMode||$EntryMode||0||$EntryMode||N"
if($EntryMode -eq 2){ $Inputs += "`nInpRetestOffsetPts=$RetestOffset||$RetestOffset||0||$RetestOffset||N" }

$mtag = if($Model -eq 4){"realtick"}else{"ohlc"}
$etag = if($EntryMode -eq 2){"retest"}else{"brk"}
$EAtag="APERT_US_M5_${etag}_$mtag"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== CONFERMA APERTURA US (M5, Model $Model) su $($Symbols -join ', ') ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_apert") | Out-Null
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_v2\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_v2\$EA.mq5" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA" -ForegroundColor Red; exit 1}

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
$Results=Join-Path $Work "risultati_$EAtag"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

$n=0
foreach($sym in $Symbols){
  $n++
  $done=Join-Path $Results "apert_${EAtag}_$sym.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Symbols.Count,$sym) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_apert\apert_${EAtag}_$sym.ini"
  @"
[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=M5
Model=$Model
Optimization=2
OptimizationCriterion=6
FromDate=2024.01.01
ToDate=2026.06.30
ForwardMode=0
Deposit=100000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_${EAtag}_$sym

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (M5 Model $Model)..." -f $n,$Symbols.Count,$sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> apert_${EAtag}_$sym.csv") -ForegroundColor Green}
  else{Write-Host ("        (no CSV: {0} senza storico/nome diverso? verifica)" -f $sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa risultati_$EAtag e caricamela: confermo se l'edge regge con la gestione reale." -ForegroundColor White
