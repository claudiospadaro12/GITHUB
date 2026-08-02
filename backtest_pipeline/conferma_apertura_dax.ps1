# =====================================================================
#  conferma_apertura_dax.ps1  --  CONFERMA col motore APERTURA REALE
#  (ABTG_DAX_Apertura_EU) l'apertura DAX, confrontando STOP vs RETEST.
#
#  Gemello di conferma_apertura_us.ps1 ma per il DAX (D30EUR, M5):
#   - EA:  ABTG_DAX_Apertura_EU
#   - orario apertura: 08:00 SERVER (= 09:00 IT, regola fuso BCM -1h)
#   - filtro H4 SPENTO: sul DAX peggiora l'edge (finding 30/07). Qui
#     confrontiamo puramente il MOTORE d'ingresso (stop vs limit).
#
#  PC FISSO, MetaTrader CHIUSO. Ripresa: salta i simboli gia' fatti.
#
#  Uso (default = OHLC veloce, BREAKOUT attuale):
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1
#
#  CONFRONTO MOTORE a TICK REALI (la vera domanda: limit batte lo stop?):
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 0
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 2
#    -> due set di CSV separati (..._brk_... vs ..._retest_...), poi si confrontano.
# =====================================================================
param(
  [string[]]$Symbols=@("D30EUR"),
  [int]$Model=1,                              # 1=OHLC (veloce) · 4=tick reali (verita')
  [int]$EntryMode=0,                          # 0=BREAKOUT (stop) · 2=RETEST (limit) · 3=RANGE_FADE (fada gli estremi)
  [double]$RetestOffset=0,                     # (solo RETEST) offset del limit DENTRO il livello, in punti
  [double]$FadeOffset=0,                        # (solo RANGE_FADE) offset del limit OLTRE l'estremo, in punti
  [int]$RangeMin=0,                            # se >0 forza InpRangeMinutes (es. 15 = ORB dei primi 15 min)
  [string]$EABranch="claude/chat-ea-market-openings-zoba2j", # branch con l'EA aggiornato
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_DAX_Apertura_EU"                     # motore DAX/EU
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- INPUT: apertura DAX 08:00 server, filtro H4 SPENTO; buffer in mini-griglia ---
$Inputs=@"
InpSessionHour=8||8||0||8||N
InpSessionMin=0||0||0||0||N
InpUseEmaFilter=0||0||0||0||N
InpUseSupertrend=0||0||0||0||N
InpUseCorrelation=0||0||0||0||N
InpUseVwapFilter=0||0||0||0||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpBufferPoints=200||100||100||400||Y
"@

# --- modalita' d'ingresso: BREAKOUT (0) / RETEST (2) / RANGE_FADE (3) ---
$Inputs += "`nInpEntryMode=$EntryMode||$EntryMode||0||$EntryMode||N"
if($EntryMode -eq 2){ $Inputs += "`nInpRetestOffsetPts=$RetestOffset||$RetestOffset||0||$RetestOffset||N" }
if($EntryMode -eq 3){ $Inputs += "`nInpFadeOffsetPts=$FadeOffset||$FadeOffset||0||$FadeOffset||N" }
if($RangeMin -gt 0){ $Inputs += "`nInpRangeMinutes=$RangeMin||$RangeMin||0||$RangeMin||N" }

$mtag = if($Model -eq 4){"realtick"}else{"ohlc"}
$etag = if($EntryMode -eq 3){"fade"}elseif($EntryMode -eq 2){"retest"}else{"brk"}
if($RangeMin -gt 0){ $etag = "${etag}_orb$RangeMin" }
$EAtag="APERT_DAX_M5_${etag}_$mtag"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== CONFERMA APERTURA DAX (M5, Model $Model, $etag) su $($Symbols -join ', ') ===" -ForegroundColor Cyan
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
  # il tester a volte lascia terminal64 appeso (es. simbolo senza storico) -> lo chiudo,
  # cosi' il test successivo (o lo script successivo) non si blocca su "Chiudi MetaTrader".
  for($__w=0;$__w -lt 20;$__w++){ if(-not (Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){break}; Start-Sleep -Seconds 3 }
  Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> apert_${EAtag}_$sym.csv") -ForegroundColor Green}
  else{Write-Host ("        (no CSV: {0} senza storico/nome diverso? verifica)" -f $sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa risultati_$EAtag e caricamela: confronto STOP vs RETEST sul DAX." -ForegroundColor White
