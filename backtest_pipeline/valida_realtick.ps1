# =====================================================================
#  valida_realtick.ps1  --  FASE 2 (VALIDAZIONE): ri-testa i VINCITORI
#  dello scan OHLC a TICK REALI (Model 4), con spread e fill veri.
#
#  Serve a separare l'edge VERO dai numeri gonfiati dell'OHLC. Solo cio'
#  che regge qui merita il forward / il Multi.
#
#  PC FISSO, MetaTrader CHIUSO. Ripresa: salta i simboli gia' fatti.
#
#  Uso (default = vincitori robusti SupertrendReversal H4):
#    powershell -ExecutionPolicy Bypass -File .\valida_realtick.ps1
#  Cambia EA (SupertrendReversal | EMA200 | GoldenCross):
#    .\valida_realtick.ps1 -Robot ABTG_EMA200 -Symbols 200AUD,AUDJPY,GBPUSD
#  Personalizza i simboli:
#    .\valida_realtick.ps1 -Symbols XAUUSD,U30USD,225JPY
#  Cambia TF (per validare l'H1 quando lo scan H1 avra' i suoi vincitori):
#    .\valida_realtick.ps1 -Tf H1
# =====================================================================
param(
  [string]$Robot="ABTG_SupertrendReversal",  # EA da validare: ABTG_SupertrendReversal | ABTG_EMA200 | ABTG_GoldenCross
  [string[]]$Symbols=@("XAUUSD","XAGUSD","U30USD","225JPY","D30EUR","200AUD"), # metalli + indici (candidati Multi)
  [string]$Tf="H4",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# --- 14/08: con "powershell -File" gli argomenti arrivano come STRINGHE
#     LETTERALI: "-Symbols A,B,C" diventava UN solo simbolo di nome
#     "A,B,C" (il tester cercava uno strumento inesistente e scriveva
#     zero CSV, senza errore rosso). Qui la lista si normalizza sempre.
if($Symbols.Count -eq 1 -and $Symbols[0] -like "*,*"){
  $Symbols = $Symbols[0].Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}
$EA=$Robot
$EABranch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore   # dove vivono gli EA di trading
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$tfmap=@{ "M5"=5; "M15"=15; "M30"=30; "H1"=16385; "H4"=16388; "D1"=16408 }
if(-not $tfmap.ContainsKey($Tf)){ Write-Host "-Tf non valido: M5,M15,M30,H1,H4,D1" -ForegroundColor Red; exit 1 }
$en=$tfmap[$Tf]

# --- GRIGLIA FOCALIZZATA a tick reali PER EA (compatta: la validazione conferma, non riscopre) ---
if($EA -eq "ABTG_EMA200"){
  # Rimbalzo su EMA200: direzione (L/S) + TP_RR 1.5-3.0.
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_RR=1.5||1.5||0.5||3.0||Y
"@
} elseif($EA -eq "ABTG_GoldenCross"){
  # Incrocio medie + ADX: direzione + TP.
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_R=1.5||1.5||0.5||3.0||Y
InpAdxMin=25||20||5||30||Y
"@
} elseif($EA -eq "ABTG_BreakingBand"){
  # Breaking Band: taratura CAL1 PINNATA (1.35/1.0), spazzola solo PatternMode.
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpPatternMode=0||0||1||2||Y
InpTPMode=0||0||0||0||N
InpBulgeWidthMult=1.35||1.35||0||1.35||N
InpBulgeNetMoveATR=1.0||1.0||0||1.0||N
"@
} elseif($EA -eq "ABTG_GapFill"){
  # Gap-fill weekend: taratura di tesi PINNATA, spazzola solo il target.
  # A tick reali il filtro spread e' ACCESO (300 = 3 pip forex): la
  # riapertura domenicale e' la trappola n.1 dichiarata in tesi.
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpGapMinATR=0.3||0.3||0||0.3||N
InpGapMaxATR=2.0||2.0||0||2.0||N
InpSLMode=0||0||0||0||N
InpSLGapMult=1.0||1.0||0||1.0||N
InpMaxHours=48||48||0||48||N
InpMaxSpreadPts=300||300||0||300||N
InpEntryWindowBars=3||3||0||3||N
InpFillPct=100||50||25||100||Y
"@
} elseif($EA -eq "ABTG_EasyTrend"){
  # Easy Trend: detector PINNATO dalla CAL (src0/R3), spazzola solo il
  # target (1.0 = il RR 1:1 della fonte, 1.5 = quello che vince nello
  # scan) x i lati. A tick reali lo spread e' ACCESO (30 = 3 pip forex,
  # coerente col buffer di stop della strategia).
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpPivotSource=0||0||0||0||N
InpPivotR=3||3||0||3||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpMaxSpreadPts=30||30||0||30||N
InpEntryWindowBars=3||3||0||3||N
InpWarmupBars=500||500||0||500||N
InpTP_R=1.0||1.0||0.5||1.5||Y
InpAllowLong=1||0||1||1||Y
InpAllowShort=1||0||1||1||Y
"@
} else {
  # SupertrendReversal (default): direzione (L/S), StMult 2.0-3.5, TP_RR 2.0-3.0, StAtrPeriod fisso 10.
  $Inputs=@"
InpTF=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpStAtrPeriod=10||10||0||10||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpStMult=2.5||2.0||0.5||3.5||Y
InpTP_RR=2.0||2.0||0.5||3.0||Y
"@
}

$EAtag="${EA}_${Tf}_realtick"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== VALIDAZIONE TICK REALI: $EA $Tf su $($Symbols.Count) simboli (Model 4) ===" -ForegroundColor Cyan
Write-Host "   Simboli: $($Symbols -join ', ')" -ForegroundColor Gray
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_valid") | Out-Null
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
$Results=Join-Path $Work "risultati_valid_$EAtag"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

$n=0
foreach($sym in $Symbols){
  $n++
  $done=Join-Path $Results "valid_${EAtag}_$sym.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Symbols.Count,$sym) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_valid\valid_${EA}_${Tf}_$sym.ini"
  @"
[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=$Tf
Model=4
Optimization=2
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
Report=OptReport_valid_${EAtag}_$sym

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (TICK REALI $Tf)... puo' volerci un po'" -f $n,$Symbols.Count,$sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> valid_${EAtag}_$sym.csv") -ForegroundColor Green}
  else{Write-Host ("        (no CSV: {0} senza storico tick/nome diverso? verifica)" -f $sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
# --- raccolta automatica sul Desktop + zip (regola delle righe di lancio:
#     il risultato deve SEMPRE arrivare pronto da mandare, senza path a mano) ---
$Dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "valid_$EAtag"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item (Join-Path $Results "*.csv") $Dest -Force -ErrorAction SilentlyContinue
$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "valid_$EAtag.zip"
Compress-Archive -Path (Join-Path $Dest "*") -DestinationPath $zip -Force
$n = (Get-ChildItem $Dest -File -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Host ("RACCOLTA: {0} CSV in {1} -> {2}" -f $n, $Dest, $zip) -ForegroundColor Green
Write-Host "Carica lo zip: confronto PF/DD tick-reali vs OHLC e ti dico chi regge davvero." -ForegroundColor White
