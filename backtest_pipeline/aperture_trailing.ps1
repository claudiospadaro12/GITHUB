# =====================================================================
#  aperture_trailing.ps1  --  il trailing a BASE CANDELA su DAX e Nasdaq
#
#  BINARIO 2 della rotta del 05/08. Nasce da due fatti indipendenti:
#
#   * FORWARD 04/08 (DAX, stesso simbolo/ora/direzione): il trailing a
#     base candela ha catturato 25,64 punti contro 1,90 di quello a punti
#     fissi. Tredici volte tanto.
#   * BACKTEST 05/08 (Dow, 30 pass): base candela M5 -> PF 1,371 contro
#     1,238 della gestione nuda, DD 5,32% contro 6,92%, Sharpe +69%,
#     a parita' di profit e di trade.
#
#  L'indizio originale veniva dal DAX, ma su DAX e Nasdaq quel tipo di
#  trailing NON e' mai stato misurato a backtest. Questo lo fa.
#
#  Ogni mercato gira con la sua selezione MIGLIORE nota, non con una
#  generica:
#    DAX    -> nessun filtro (nove provati, nessuno funziona sul DAX;
#              il trend H4 lo peggiora: -0,043 R/trade nella FASE A)
#    Nasdaq -> filtro VOLUMI a 1,5x, l'unico che sposta qualcosa
#              (ablazione: PF 0,90 -> 1,15 con 152 trade)
#
#  12 pass per mercato, 24 in tutto. Dentro c'e' anche il riferimento:
#  il pass con InpUseTrailing=0 e' la gestione NUDA, cioe' il numero da
#  battere. (Con il trailing spento il TF e' inerte: 6 pass su 12 danno
#  lo stesso risultato, e' previsto.)
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\aperture_trailing.ps1
# =====================================================================
param(
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- i due mercati, ciascuno con la sua selezione migliore nota ---
$Jobs=@(
  @{ Nome="DAX";    EA="ABTG_DAX_Apertura_EU";    Sym="D30EUR"; Ora=8;  Min=0;  Ema=0; Vol=0 },
  @{ Nome="NASDAQ"; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30; Ema=0; Vol=1 }
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== TRAILING A BASE CANDELA su DAX e NASDAQ (tick reali) ===" -ForegroundColor Cyan
Write-Host "    12 pass per mercato. Dentro c'e' anche la gestione NUDA come riferimento." -ForegroundColor Gray

# --- terminale + cartella dati ---
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
$Results=Join-Path $Work "risultati_aperture_trailing"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_at")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

foreach($j in $Jobs){
  Write-Host ""
  Write-Host "--- $($j.Nome) : $($j.EA) su $($j.Sym), apertura $($j.Ora):$('{0:d2}' -f $j.Min) server ---" -ForegroundColor Cyan

  $src=Join-Path $Work "src_at\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing
       Write-Host "    scaricato $($j.EA).mq5 (da $EABranch)" -ForegroundColor Green }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione" -ForegroundColor Red; continue }
  Write-Host "    compilato" -ForegroundColor Green

  # Tutto pinnato tranne le due cose che si vogliono misurare:
  #   InpUseTrailing  0/1  -> il pass con 0 e' la gestione NUDA di riferimento
  #   InpTrailTF      M1..M6 -> quale candela regge il trailing
  $Inputs=@"
InpSessionHour=$($j.Ora)||$($j.Ora)||0||$($j.Ora)||N
InpSessionMin=$($j.Min)||$($j.Min)||0||$($j.Min)||N
InpRangeMinutes=15||15||0||15||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
InpEntryMode=0||0||0||0||N
InpRangeMode=0||0||0||0||N
InpBufferPoints=200||200||0||200||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpUseGapFill=0||0||0||0||N
InpUseSupertrend=0||0||0||0||N
InpUseSupertrend3=0||0||0||0||N
InpUseCorrelation=0||0||0||0||N
InpUseVwapFilter=0||0||0||0||N
InpUseRoundLevels=0||0||0||0||N
InpUseNewsFilter=0||0||0||0||N
InpUseAtrFilter=0||0||0||0||N
InpConfirmMode=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSLMode=0||0||0||0||N
InpMinStopPts=500||500||0||500||N
InpSkipIfTight=0||0||0||0||N
InpTP1_R=0.5||0.5||0||0.5||N
InpTP1_ClosePct=0||0||0||0||N
InpBreakevenAtTP1=0||0||0||0||N
InpBEatR=0||0||0||0||N
InpUseEmaFilter=$($j.Ema)||$($j.Ema)||0||$($j.Ema)||N
InpEmaFast=1||1||0||1||N
InpEmaSlow=50||50||0||50||N
InpFilterTF=16388||16388||0||16388||N
InpUseVolumeFilter=$($j.Vol)||$($j.Vol)||0||$($j.Vol)||N
InpVolMult=1.5||1.5||0||1.5||N
InpVolAvgBars=20||20||0||20||N
InpTrailMode=1||1||0||1||N
InpUseTrailing=0||0||1||1||Y
InpTrailTF=1||1||1||6||Y
"@

  $tag="$($j.Nome)_trailing"
  $ini=Join-Path $Work "at_$tag.ini"
@"
[Tester]
Expert=$($j.EA).ex5
Symbol=$($j.Sym)
Period=M5
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

  $csv=Join-Path $MqlFiles "OptResults_$($j.EA)_$($j.Sym).csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  Write-Host "    avvio 12 pass (TICK REALI M5, 2024.01 - 2026.06)... ci vuole parecchio" -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  $done=Join-Path $Results "$tag.csv"
  if(Test-Path $csv){
    try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
         Write-Host "    OK -> $done" -ForegroundColor Green }
    catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
  }else{
    Write-Host "    (nessun CSV per $tag: storico tick mancante su $($j.Sym)?)" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "=== FINITO === Zippa la cartella 'risultati_aperture_trailing' e caricamela." -ForegroundColor White
