# =====================================================================
#  valida_realtick_gc.ps1  --  VALIDAZIONE a TICK REALI (Model 4) dei
#  vincitori dello scan GoldenCross (motore trend, forex).
#
#  Gemello di valida_realtick.ps1 ma per ABTG_GoldenCross (input diversi).
#  Serve a separare l'edge vero dai numeri OHLC. PC FISSO, MT5 CHIUSO.
#  Ripresa: salta i simboli gia' fatti.
#
#  Uso (default = migliori forex GoldenCross H4):
#    powershell -ExecutionPolicy Bypass -File .\valida_realtick_gc.ps1
#  Personalizza:
#    .\valida_realtick_gc.ps1 -Symbols USDCHF,CHFJPY -Tf H4
# =====================================================================
param(
  [string[]]$Symbols=@("USDCHF","CHFJPY","EURJPY","EURUSD","NZDUSD","EURAUD","USDCAD","XAGUSD"),
  [string]$Tf="H4",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# --- 14/08: "powershell -File" passa gli argomenti come STRINGHE letterali,
#     quindi "-Symbols A,B,C" arrivava come UN elemento solo. Normalizzo. ---
if($Symbols.Count -eq 1 -and $Symbols[0] -like "*,*"){
  $Symbols = $Symbols[0].Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}
$EA="ABTG_GoldenCross"
$EABranch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$tfmap=@{ "M5"=5; "M15"=15; "M30"=30; "H1"=16385; "H4"=16388; "D1"=16408 }
if(-not $tfmap.ContainsKey($Tf)){ Write-Host "-Tf non valido: M5,M15,M30,H1,H4,D1" -ForegroundColor Red; exit 1 }
$en=$tfmap[$Tf]

# --- GRIGLIA FOCALIZZATA (conferma, non riscopre): direzione + TP_R + SL_ATR + ADX ---
$Inputs=@"
InpTimeframe=$en||$en||0||$en||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpTP_R=2.0||1.5||0.5||3.0||Y
InpAtrSLmult=1.5||1.0||0.5||2.0||Y
InpAdxMin=20||20||5||25||Y
"@

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
  # 12/09/2026: TOLTO IL RIPIEGO CHE ALLARGAVA IL BERSAGLIO.
  # Qui c'era: se il selettore stretto non ha trovato niente, cerca
  # "*BCM Markets*" e prendi il PRIMO. Due difetti in una riga sola:
  #  - "*BCM Markets*" comprende anche il 100k -V3 (50504263);
  #  - "-First 1" su un insieme trovato per RICERCA non e' una scelta,
  #    e' un SORTEGGIO: nessun ordinamento, cioe' "quello che il
  #    filesystem ha restituito per primo".
  # E questo script SCRIVE e RICOMPILA dentro il terminale che sceglie.
  # Il bersaglio non si allarga mai da solo: si muore.
  if(-not $c){
    # 12/09/2026 (cancello): qui avevo messo "exit 1", e in 30 script su 84
    # quel blocco sta DENTRO un try{} il cui catch{} scrive il referto e fa
    # lo zip da mandare. Con exit il processo muore sul posto: niente catch,
    # niente referto, NIENTE ZIP -- cioe' la regola delle righe di lancio
    # (punto 2: si raccoglie sempre) annullata proprio nel caso in cui serve
    # di piu'. Con throw il catch la raccoglie e la raccolta parte; e dove il
    # try non c'e', throw termina comunque lo script. Sicuro in tutti e due.
    throw "Terminale non trovato col selettore stretto, e NON allargo la ricerca: il ripiego '*BCM Markets*' comprendeva anche il 100k -V3 (50504263), e questo script scrive e compila dentro il terminale che sceglie. Nomina il terminale a mano, oppure passa il banco C:\MT5_Backtest."
  }
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
[Experts]
AllowLiveTrading=false
AllowDllImport=false

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
Write-Host "Zippa risultati_valid_$EAtag e caricamela: confronto PF/DD tick-reali vs OHLC." -ForegroundColor White
