# =====================================================================
#  aperture_ingresso.ps1  --  la GEOMETRIA dell'ingresso, mai testata
#
#  Osservazione di Claudio (05/08): abbiamo ottimizzato la gestione fino
#  in fondo, ma la logica d'INGRESSO l'abbiamo data per buona.
#  Ha ragione, e per due motivi:
#
#  1) I DUE NUMERI DI BASE NON SONO MAI STATI MISURATI.
#     - InpRangeMinutes = 15  -> viene dal PDF di Emiliano ("primi 15
#       minuti"), non da un backtest. Non e' mai stato spazzolato.
#     - InpBufferPoints = 200 -> scelto a occhio. Sul Nasdaq si e' visto
#       che sotto i 100 punti e' INERTE (sta dentro lo spread), ma sopra
#       non e' mai stato esplorato sul serio.
#     Tutto il sistema delle aperture poggia su questi due valori.
#
#  2) I MOTORI BOCCIATI LO SONO STATI CON LA GESTIONE SBAGLIATA.
#     RETEST e RANGE_FADE furono testati a luglio con TP a 3R
#     (irraggiungibile) e trailing fisso a 0,07 R -- cioe' esattamente le
#     due cose che il 04-05/08 si sono rivelate distruttive. Quelle
#     bocciature non sono definitive quanto sembravano.
#
#  Qui si tiene FISSA la gestione validata sul Dow (TP 1,5R + trailing a
#  base candela, niente parziale ne' BE) e si spazzola la geometria:
#     InpRangeMinutes  5 / 15 / 25 / 35 / 45     (quanto dura il range)
#     InpBufferPoints  100 / 300 / 500 / 700     (quanto oltre l'estremo)
#  20 pass per mercato.
#
#  ⚠️ Da lanciare DOPO aperture_trailing.ps1: quello decide il TF del
#     trailing per DAX/Nasdaq, che qui va passato con -TrailTF.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\aperture_ingresso.ps1
#    .\aperture_ingresso.ps1 -TrailTF 3          (se il test dice M3)
#    .\aperture_ingresso.ps1 -UseTrailing 0      (se il trailing non paga)
# =====================================================================
param(
  [int]$TrailTF=5,          # TF della candela per il trailing (dal test precedente)
  [int]$UseTrailing=1,      # 0 = gestione nuda, se il trailing non ha pagato
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$Jobs=@(
  @{ Nome="DAX";    EA="ABTG_DAX_Apertura_EU";    Sym="D30EUR"; Ora=8;  Min=0;  Ema=0; Vol=0 },
  @{ Nome="NASDAQ"; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30; Ema=0; Vol=1 }
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== GEOMETRIA DELL'INGRESSO: durata del range x buffer (tick reali) ===" -ForegroundColor Cyan
Write-Host "    Gestione fissata: TP 1,5R, trailing=$UseTrailing su M$TrailTF, niente parziale ne BE." -ForegroundColor Gray
Write-Host "    20 pass per mercato." -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_aperture_ingresso"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_ai")|Out-Null
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
InpOCTimeframe=0||0||0||0||N
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

  $src=Join-Path $Work "src_ai\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing
       Write-Host "    scaricato $($j.EA).mq5" -ForegroundColor Green }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione" -ForegroundColor Red; continue }
  Write-Host "    compilato" -ForegroundColor Green

  # In sweep SOLO la geometria dell'ingresso. Tutto il resto e' pinnato,
  # gestione compresa: cosi' l'unica cosa che cambia e' DOVE e QUANDO entra.
  $Inputs=@"
InpSessionHour=$($j.Ora)||$($j.Ora)||0||$($j.Ora)||N
InpSessionMin=$($j.Min)||$($j.Min)||0||$($j.Min)||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
InpEntryMode=0||0||0||0||N
InpRangeMode=0||0||0||0||N
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
InpUseTrailing=$UseTrailing||$UseTrailing||0||$UseTrailing||N
InpTrailMode=1||1||0||1||N
InpTrailTF=$TrailTF||$TrailTF||0||$TrailTF||N
InpUseEmaFilter=$($j.Ema)||$($j.Ema)||0||$($j.Ema)||N
InpUseVolumeFilter=$($j.Vol)||$($j.Vol)||0||$($j.Vol)||N
InpRangeMinutes=15||5||10||45||Y
InpBufferPoints=300||100||200||700||Y
$Blindatura
"@

  $tag="$($j.Nome)_ingresso"
  $ini=Join-Path $Work "ai_$tag.ini"
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
  Write-Host "    avvio 20 pass (TICK REALI M5, 2024.01 - 2026.06)..." -ForegroundColor Cyan
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
Write-Host "=== FINITO === Zippa 'risultati_aperture_ingresso' e caricamela." -ForegroundColor White
