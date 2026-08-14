# =====================================================================
#  rilancia_scan_market.ps1  --  SCAN di un EA su TUTTO il market
#  (tutti i simboli della lista) in OHLC, per scoprire su quali
#  strumenti rende di piu' in ~2,5 anni.
#
#  Uso:
#    .\rilancia_scan_market.ps1 -EA ABTG_MaxMinNotte
#    .\rilancia_scan_market.ps1 -EA ABTG_Nightly
#
#  Come funziona: per ogni simbolo genera un .ini al volo, lancia l'EA
#  in OHLC (Model 1) con una piccola griglia, salva un CSV per simbolo
#  in .\risultati_scan_<EA>\. Poi Claudio manda i CSV e Claude
#  classifica gli strumenti per PF (filtro: almeno N trade).
#  Ripresa: salta i simboli gia' fatti.
#
#  NB: ogni simbolo deve avere lo storico scaricato. Quelli senza dati
#  (o con nome diverso sul tuo BCM) danno 0 trade e vengono saltati.
#  SL ad ATR (agnostico). Rischio 1%.
# =====================================================================
param(
  [Parameter(Mandatory=$true)][string]$Robot,   # ABTG_MaxMinNotte | ABTG_Nightly
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
$EA=$Robot   # (rinominato: -EA e' riservato da PowerShell come alias di -ErrorAction)
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

# --- LISTA SIMBOLI (modifica se sul tuo BCM hanno nomi diversi) -------
$Symbols=@(
  # Indici
  "D30EUR","NASUSD","U30USD","SPXUSD","100GBP","F40EUR","E50EUR","E35EUR","200AUD","225JPY",
  # Metalli / energia
  "XAUUSD","XAGUSD","XPTUSD","XPDUSD","UKOIL","USOIL","XNGUSD",
  # Forex majors
  "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
  # Forex cross
  "EURGBP","EURJPY","EURCHF","EURAUD","EURCAD","EURNZD","GBPJPY","GBPCHF","GBPAUD","GBPCAD","GBPNZD",
  "AUDJPY","CADJPY","CHFJPY","NZDJPY","CADCHF","NZDCAD","NZDCHF",
  # Forex esotici EU
  "EURNOK","USDNOK","EURPLN","USDPLN","EURSEK","USDSEK"
)

# --- GRIGLIA per EA (OHLC, Model 1) -----------------------------------
if($EA -eq "ABTG_MaxMinNotte"){
  $Inputs=@"
InpSLMode=1||1||0||1||N
InpAtrSLmult=1.5||1.5||0||1.5||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
InpBufferPoints=200||200||1400||3000||Y
"@
} elseif($EA -eq "ABTG_Nightly"){
  $Inputs=@"
InpSLpips=0||0||0||0||N
InpSLatrMult=1.0||1.0||0.5||1.5||Y
InpRiskPercent=1.0||1.0||0||1.0||N
InpAllowLong=0||0||1||1||Y
InpAllowShort=0||0||1||1||Y
"@
} else { Write-Host "EA non gestito: usa ABTG_MaxMinNotte o ABTG_Nightly" -ForegroundColor Red; exit 1 }

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== SCAN MARKET: $EA su $($Symbols.Count) simboli (OHLC) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_scan") | Out-Null
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
$Results=Join-Path $Work "risultati_scan_$EA"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green
$n=0
foreach($sym in $Symbols){
  $n++
  $done=Join-Path $Results "scan_${EA}_$sym.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Symbols.Count,$sym) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_scan\scan_${EA}_$sym.ini"
  @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=H1
Model=1
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
Report=OptReport_scan_${EA}_$sym

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (OHLC)..." -f $n,$Symbols.Count,$sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
  if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host ("        OK -> scan_${EA}_$sym.csv") -ForegroundColor Green}
  else{Write-Host ("        (no CSV: {0} senza storico/nome diverso? salto)" -f $sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa la cartella risultati_scan_$EA e caricamela (o mandami i CSV): classifico gli strumenti per PF." -ForegroundColor White
