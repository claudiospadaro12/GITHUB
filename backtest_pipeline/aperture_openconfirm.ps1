# =====================================================================
#  aperture_openconfirm.ps1  --  inseguire la rottura, o aspettare che
#                                la candela APRA gia' oltre?
#
#  Intuizione di Claudio (05/08): "quando apre la candela ORB alle 9:15
#  italiane, quella puo' essere un punto di riferimento per l'EA sul DAX".
#
#  Meta' della cosa c'era gia': l'EA del DAX usa RANGE_MODE=0 con
#  InpRangeMinutes=15 e apertura alle 08:00 server, cioe' il range e'
#  ESATTAMENTE la candela 09:00-09:15 italiane. Lo stesso riferimento.
#
#  Quello che NON c'era e' COME ci si entra sopra:
#    - noi:      ordini pendenti STOP appoggiati al livello
#    - le live:  "mi apre la candela sotto E c'e' un incremento dei
#                 volumi, io li' lo shorto"
#
#  E' una differenza con un peso misurato: il 04/08 lo sweep d'apertura
#  ha preso i due Live5m proprio perche' avevano pendenti sul livello
#  (DAX stoppato in 61 s; Nasdaq in 20 s dopo aver venduto 133 punti
#  SOPRA il massimo notturno, in un mercato chiuso a +1,80%).
#  Una candela che APRE oltre non puo' essere prodotta da uno sweep:
#  lo sweep e' intra-candela.
#
#  Da qui la modalita' InpEntryMode=5 (OPENCONFIRM), aggiunta il 05/08.
#
#  4 pass per mercato: BREAKOUT vs OPENCONFIRM x volumi OFF/ON.
#  Piccolo e decisivo. Gestione fissata a quella validata sul Dow.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\aperture_openconfirm.ps1
# =====================================================================
param(
  [int]$OCTimeframe=0,   # 0 = TF del grafico (M5). Metti 15 per valutare come nelle live, su M15.
  [int]$TrailTF=5,
  [int]$UseTrailing=1,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$Jobs=@(
  @{ Nome="DAX";    EA="ABTG_DAX_Apertura_EU";    Sym="D30EUR"; Ora=8;  Min=0  },
  @{ Nome="NASDAQ"; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30 }
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== INSEGUIRE LA ROTTURA vs ASPETTARE CHE LA CANDELA APRA OLTRE ===" -ForegroundColor Cyan
Write-Host "    4 pass per mercato: BREAKOUT vs OPENCONFIRM x volumi OFF/ON." -ForegroundColor Gray
Write-Host "    Range = candela 15 min dopo l'apertura (09:00-09:15 IT sul DAX)." -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_openconfirm"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_oc")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

# --- BLINDATURA (05/08) -------------------------------------------------
# I parametri NON elencati qui MT5 se li tiene dallo stato precedente del
# terminale, comprese le impostazioni di ottimizzazione. Risultato: nel
# test del trailing e in quello dell'ingresso il terminale ha spazzolato
# da solo InpTrailFixedPts su 8 valori, moltiplicando i pass per 8
# (160 righe invece di 20). I numeri erano giusti - quel parametro e'
# inerte con TrailMode=1 - ma il tempo macchina era 8 volte tanto.
# Da qui in poi si pinna TUTTO. Niente resta al caso.
$Blindatura=@"
InpLevelTF=16385||16385||0||16385||N
InpPrevWindowMin=60||60||0||60||N
InpMinRangePts=0||0||0||0||N
InpMaxRangePts=0||0||0||0||N
InpRetestOffsetPts=0||0||0||0||N
InpFadeOffsetPts=0||0||0||0||N
InpDelayMinutes=30||30||0||30||N
InpDelayDirMode=0||0||0||0||N
InpGapMinPoints=150||150||0||150||N
InpGapMinRR=1.5||1.5||0||1.5||N
InpStAtrPeriod=10||10||0||10||N
InpStMultiplier=2.5||2.5||0||2.5||N
InpStTF=16385||16385||0||16385||N
InpCorrTF=16385||16385||0||16385||N
InpCorrEmaFast=14||14||0||14||N
InpCorrEmaSlow=100||100||0||100||N
InpVwapTF=15||15||0||15||N
InpAtrSlMult=1.5||1.5||0||1.5||N
InpAtrPeriodMgmt=14||14||0||14||N
InpTrailAtrMult=2.0||2.0||0||2.0||N
InpTrailFixedPts=410||410||0||410||N
InpRoundStep=100.0||100.0||0||100.0||N
InpRoundMinDistPts=50||50||0||50||N
InpNewsMinImpact=3||3||0||3||N
InpNewsBeforeMin=30||30||0||30||N
InpNewsAfterMin=30||30||0||30||N
InpNewsShiftMinutes=0||0||0||0||N
InpNewsFlatten=1||1||0||1||N
InpSlippagePts=0||0||0||0||N
InpAtrFilterBars=20||20||0||20||N
InpAtrFilterMult=1.0||1.0||0||1.0||N
InpMaxSpread=0||0||0||0||N
InpPendingExpiryMin=120||120||0||120||N
InpEmaFast=1||1||0||1||N
InpEmaSlow=50||50||0||50||N
InpFilterTF=16388||16388||0||16388||N
InpVolMult=1.5||1.5||0||1.5||N
InpVolAvgBars=20||20||0||20||N
InpVerbose=1||1||0||1||N
"@
# ------------------------------------------------------------------------

foreach($j in $Jobs){
  Write-Host ""
  Write-Host "--- $($j.Nome) : $($j.Sym), apertura $($j.Ora):$('{0:d2}' -f $j.Min) server ---" -ForegroundColor Cyan

  $src=Join-Path $Work "src_oc\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing
       Write-Host "    scaricato $($j.EA).mq5" -ForegroundColor Green }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione" -ForegroundColor Red; continue }
  Write-Host "    compilato" -ForegroundColor Green

  # In sweep SOLO due cose: come si entra, e se i volumi servono.
  #   InpEntryMode        0 = BREAKOUT (pendenti stop)  ·  5 = OPENCONFIRM (candela che apre oltre)
  #   InpUseVolumeFilter  0/1
  $Inputs=@"
InpSessionHour=$($j.Ora)||$($j.Ora)||0||$($j.Ora)||N
InpSessionMin=$($j.Min)||$($j.Min)||0||$($j.Min)||N
InpRangeMinutes=15||15||0||15||N
InpRangeMode=0||0||0||0||N
InpBufferPoints=200||200||0||200||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
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
InpUseEmaFilter=0||0||0||0||N
InpConfirmMode=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSLMode=0||0||0||0||N
InpMinStopPts=500||500||0||500||N
InpSkipIfTight=0||0||0||0||N
InpTP1_R=0.5||0.5||0||0.5||N
InpTP1_ClosePct=0||0||0||0||N
InpBreakevenAtTP1=0||0||0||0||N
InpBEatR=0||0||0||0||N
InpUseTrailing=$UseTrailing||$UseTrailing||0||$UseTrailing||N
InpTrailMode=1||1||0||1||N
InpTrailTF=$TrailTF||$TrailTF||0||$TrailTF||N
InpEntryMode=0||0||5||5||Y
InpUseVolumeFilter=0||0||1||1||Y
InpOCTimeframe=$OCTimeframe||$OCTimeframe||0||$OCTimeframe||N
$Blindatura
"@

  # il TF va nel nome: altrimenti due giri con -OCTimeframe diverso si sovrascrivono
  $tfNome = if($OCTimeframe -eq 0){"graficoM5"}else{"M$OCTimeframe"}
  $tag="$($j.Nome)_openconfirm_$tfNome"
  $ini=Join-Path $Work "oc_$tag.ini"
@"
[Tester]
Expert=$($j.EA).ex5
Symbol=$($j.Sym)
Period=M5
Model=4
Optimization=1
OptimizationCriterion=6
FromDate=2024.09.26
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
  Write-Host "    avvio 4 pass (TICK REALI M5, 2024.01 - 2026.06)..." -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  $done=Join-Path $Results "$tag.csv"
  if(Test-Path $csv){
    try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
         Write-Host "    OK -> $done" -ForegroundColor Green }
    catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
  }else{
    Write-Host "    (nessun CSV per ${tag}: storico tick mancante su $($j.Sym)?)" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "=== FINITO === Zippa 'risultati_openconfirm' e caricamela." -ForegroundColor White
